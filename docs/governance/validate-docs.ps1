param(
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path,
    [switch]$RequireSigningReady
)

$ErrorActionPreference = 'Stop'
$failures = [System.Collections.Generic.List[string]]::new()
$readinessIssues = [System.Collections.Generic.List[string]]::new()

function Add-Failure([string]$Message) {
    $failures.Add($Message)
}

# Validate explicit paths in the documentation authority manifest.
$documentManifest = Join-Path $PSScriptRoot 'DOCUMENT-MANIFEST.yaml'
if (-not (Test-Path -LiteralPath $documentManifest)) {
    Add-Failure 'Missing DOCUMENT-MANIFEST.yaml'
} else {
    Get-Content -Encoding utf8 -LiteralPath $documentManifest | ForEach-Object {
        if ($_ -match '^\s+-?\s*path:\s*(.+?)\s*$') {
            $manifestPath = $Matches[1].Trim('"', "'")
            $resolvedManifestPath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $manifestPath))
            if (-not (Test-Path -LiteralPath $resolvedManifestPath)) {
                Add-Failure "Manifest path does not exist: $manifestPath"
            }
        }
    }
}

# Every documentation artifact must have an exact path or matching prefix entry.
if (Test-Path -LiteralPath $documentManifest) {
    $manifestBase = Split-Path $documentManifest
    $exactPaths = [System.Collections.Generic.List[string]]::new()
    $prefixPaths = [System.Collections.Generic.List[string]]::new()
    Get-Content -Encoding utf8 -LiteralPath $documentManifest | ForEach-Object {
        if ($_ -match '^\s+-\s+path:\s*(.+?)\s*$') {
            $exactPaths.Add([IO.Path]::GetFullPath((Join-Path $manifestBase $Matches[1].Trim('"', "'"))))
        } elseif ($_ -match '^\s+-\s+path_prefix:\s*(.+?)\s*$') {
            $prefixPaths.Add([IO.Path]::GetFullPath((Join-Path $manifestBase $Matches[1].Trim('"', "'"))))
        }
    }

    Get-ChildItem -LiteralPath (Join-Path $RepositoryRoot 'docs') -Recurse -File | Where-Object {
        $_.Extension -in @('.md', '.yaml', '.ps1', '.docx', '.pdf')
    } | ForEach-Object {
        $artifact = $_.FullName
        $covered = $exactPaths.Contains($artifact)
        if (-not $covered) {
            foreach ($prefix in $prefixPaths) {
                if ($artifact.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
                    $covered = $true
                    break
                }
            }
        }
        if (-not $covered) {
            Add-Failure "Documentation artifact is not classified in DOCUMENT-MANIFEST.yaml: $artifact"
        }
    }
}

# Validate local Markdown links.
Get-ChildItem -LiteralPath $RepositoryRoot -Recurse -Filter '*.md' -File | ForEach-Object {
    $file = $_
    $lineNumber = 0
    Get-Content -LiteralPath $file.FullName -Encoding utf8 | ForEach-Object {
        $lineNumber++
        foreach ($match in [regex]::Matches($_, '\[[^\]]*\]\(([^)]+)\)')) {
            $target = $match.Groups[1].Value.Trim('<', '>')
            if ($target -match '^(https?://|mailto:|#)' -or [string]::IsNullOrWhiteSpace($target)) { continue }
            $relativePath = ($target -split '#')[0]
            $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $relativePath))
            if (-not (Test-Path -LiteralPath $resolved)) {
                Add-Failure "Broken link: $($file.FullName):$lineNumber -> $target"
            }
        }
    }
}

# UTF-8 BOM can prevent exact heading/status parsing; governed text files must be BOM-free.
Get-ChildItem -LiteralPath (Join-Path $RepositoryRoot 'docs') -Recurse -File | Where-Object {
    $_.Extension -in @('.md', '.yaml', '.ps1')
} | ForEach-Object {
    $bytes = [IO.File]::ReadAllBytes($_.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Add-Failure "UTF-8 BOM is not allowed in governed text artifact: $($_.FullName)"
    }
}

# Signature verification is separate from stale generated DOCX/PDF.
$signatureManifest = Join-Path $RepositoryRoot 'docs/techHistory/phase-1/SIGNATURE-STATUS.yaml'
if (-not (Test-Path -LiteralPath $signatureManifest)) {
    Add-Failure 'Missing SIGNATURE-STATUS.yaml'
} else {
    $signatureText = Get-Content -Raw -Encoding utf8 -LiteralPath $signatureManifest
    foreach ($ownerAuthorizationRule in @(
        'status: AUTHORIZED_BY_OWNER',
        'requires_signed_source: false',
        'requires_task_go: false'
    )) {
        if ($signatureText -notmatch [regex]::Escape($ownerAuthorizationRule)) {
            Add-Failure "SIGNATURE-STATUS.yaml is missing Option A repository authorization rule: $ownerAuthorizationRule"
        }
    }
    $signedVerified = $signatureText -match 'status:\s*SIGNED_VERIFIED'
    $sourceAuthorized = $signatureText -match 'business_source_authorized:\s*true'
    $parityMatch = $signatureText -match 'parity_with_canonical:\s*MATCH'
    if (($signedVerified -or $sourceAuthorized) -and -not $parityMatch) {
        Add-Failure 'SIGNED_VERIFIED or business_source_authorized requires parity_with_canonical MATCH.'
    }
    if ($signatureText -match 'status:\s*STALE_REGENERATE_REQUIRED' -and $signatureText -match 'blocks_development:\s*true') {
        Add-Failure 'Stale generated DOCX/PDF must not block development.'
    }

    if (-not $sourceAuthorized) {
        $readinessIssues.Add('TA signed source is not verified. This affects legal/signing readiness only; repository development remains owner-authorized.')
    }

    $canonicalMatch = [regex]::Match($signatureText, 'canonical_content:\s*\r?\n\s*path:\s*([^\r\n]+)\r?\n\s*sha256:\s*([A-Fa-f0-9]{64})')
    if (-not $canonicalMatch.Success) {
        Add-Failure 'Cannot parse canonical content path/hash from signature manifest.'
    } else {
        $canonicalPath = Join-Path (Split-Path $signatureManifest) $canonicalMatch.Groups[1].Value.Trim()
        if (-not (Test-Path -LiteralPath $canonicalPath)) {
            Add-Failure "Canonical contract file is missing: $canonicalPath"
        } else {
            $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $canonicalPath).Hash
            if ($actualHash -ne $canonicalMatch.Groups[2].Value.ToUpperInvariant()) {
                Add-Failure 'Canonical contract hash differs from SIGNATURE-STATUS.yaml.'
            }
        }
    }

    $signedArtifactMatch = [regex]::Match($signatureText, 'signed_source:\s*\r?\n\s*status:\s*[^\r\n]+\r?\n\s*path:\s*([^\r\n]+)\r?\n\s*sha256:\s*([A-Fa-f0-9]{64})')
    if ($signedVerified) {
        if (-not $signedArtifactMatch.Success) {
            Add-Failure 'SIGNED_VERIFIED requires signed_source path and sha256.'
        } else {
            $signedRelative = $signedArtifactMatch.Groups[1].Value.Trim()
            $signedPath = Join-Path (Split-Path $signatureManifest) $signedRelative
            if (-not (Test-Path -LiteralPath $signedPath)) {
                Add-Failure "Signed artifact is missing: $signedPath"
            } else {
                $signedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $signedPath).Hash
                if ($signedHash -ne $signedArtifactMatch.Groups[2].Value.ToUpperInvariant()) {
                    Add-Failure 'Signed artifact hash differs from SIGNATURE-STATUS.yaml.'
                }
            }
        }
    } elseif (-not $signedArtifactMatch.Success) {
        Add-Failure 'signed_source path and sha256 must be parseable.'
    } else {
        $signedRelative = $signedArtifactMatch.Groups[1].Value.Trim()
        $signedPath = Join-Path (Split-Path $signatureManifest) $signedRelative
        if (-not (Test-Path -LiteralPath $signedPath)) {
            Add-Failure "Submitted signature photograph is missing: $signedPath"
        } else {
            $signedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $signedPath).Hash
            if ($signedHash -ne $signedArtifactMatch.Groups[2].Value.ToUpperInvariant()) {
                Add-Failure 'Submitted signature photograph hash differs from SIGNATURE-STATUS.yaml.'
            }
        }
    }
}

# Guard against accidental return to coarse range-only traceability.
$traceability = Join-Path $RepositoryRoot 'docs/requirements/PHASE-1-TRACEABILITY.md'
$traceText = Get-Content -Raw -Encoding utf8 -LiteralPath $traceability
foreach ($requiredId in @('REG-01', 'AMB-01', 'INP-01', 'DIA-01', 'LAB-01', 'RAD-01', 'FDI-01', 'END-01', 'TRT-01', 'FIN-01', 'REP-01', 'ADM-01')) {
    if ($traceText -notmatch [regex]::Escape("| $requiredId |")) {
        Add-Failure "Missing requirement-level trace row: $requiredId"
    }
}

# Guard the workflow register against collapsing distinct actions/lifecycles into enums.
$workflowRegister = Join-Path $RepositoryRoot 'docs/requirements/WORKFLOW-TRANSITIONS.md'
$workflowText = Get-Content -Raw -Encoding utf8 -LiteralPath $workflowRegister
if ($workflowText -notmatch 'NO_ENUM_OR_LINEAR_STATE_MACHINE_UNTIL_APPROVED') {
    Add-Failure 'Workflow register must forbid enum or linear state-machine inference from known lifecycle facts.'
}
if ($workflowText -match '\| Diagnostic order lifecycle \| DIA-01(?:-|\u2013)04 \|') {
    Add-Failure 'DIA-04 must not be classified as part of the diagnostic order lifecycle.'
}
if ($workflowText -match '\| Financial operation \| FIN-03(?:-|\u2013)13 \|') {
    Add-Failure 'Distinct financial operations must not be collapsed into one lifecycle row.'
}
if ($workflowText -notmatch '\| Laboratory specimen lifecycle \| LAB-01 \|') {
    Add-Failure 'LAB-01 specimen lifecycle must have its own blocker row.'
}
if ($workflowText -match '\| Queue/appointment \| REG-04(?:-|\u2013)06 \|') {
    Add-Failure 'REG schedule, appointment, and queue concerns must not be collapsed into one lifecycle row.'
}
if ($workflowText -match '\| Radiology result lifecycle \| RAD-01(?:-|\u2013)03 \|') {
    Add-Failure 'RAD order/execution, result, attachment, and applicability concerns must not be collapsed into one result lifecycle row.'
}
if ($workflowText -notmatch '\| Clinician queue lifecycle \| REG-06 \|') {
    Add-Failure 'REG-06 clinician queue lifecycle must have its own blocker row.'
}
if ($workflowText -notmatch '\| Laboratory result lifecycle \| LAB-03 \|') {
    Add-Failure 'Only LAB-03 may own the laboratory result lifecycle row.'
}
if ($workflowText -match '\| Laboratory result lifecycle \| LAB-02(?:-|\u2013)04 \|') {
    Add-Failure 'LAB-02 data entry and LAB-04 critical fact must not be folded into the LAB-03 lifecycle.'
}
$rad01RowCount = ([regex]::Matches($workflowText, '(?m)^\|[^\r\n]*\| RAD-01 \|')).Count
if ($rad01RowCount -ne 1) {
    Add-Failure "RAD-01 must have exactly one composite blocker row; found $rad01RowCount."
}

# Traceability blockers must describe the same requirement ID as the contract row.
foreach ($mapping in @(
    @{ Id = 'LAB-03'; Required = 'result draft/technical-check/professional-approval/correction' },
    @{ Id = 'LAB-04'; Required = 'critical-result threshold source and clinician-notification fact' },
    @{ Id = 'RAD-01'; Required = 'order/scheduling/execution vs result draft/approval boundary' },
    @{ Id = 'RAD-02'; Required = 'PDF/image format, size, storage' },
    @{ Id = 'RAD-03'; Required = 'client-approved applicable service list' },
    @{ Id = 'FIN-05'; Required = 'prepayment receipt/link/use/allocation/balance' },
    @{ Id = 'FIN-06'; Required = 'partial-payment allocation, unpaid-balance calculation' }
)) {
    if ($traceText -notmatch ('(?m)^\| ' + [regex]::Escape($mapping.Id) + ' \|[^\r\n]*' + [regex]::Escape($mapping.Required))) {
        Add-Failure "Traceability blocker does not match requirement $($mapping.Id)."
    }
}

$gateText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/00-IMPLEMENTATION-GATE.md')
$clarification32Text = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/decisions/client/32_Client_Clarifications_Resolution_Phase_1_HY.md')
if ($gateText -notmatch 'REP[^\r\n]*formula/grain/time/rounding/access' -or $clarification32Text -notmatch 'formula, grain, time semantics, rounding') {
    Add-Failure 'Reporting gate/clarification must explicitly keep calculation semantics blocked.'
}
$reportRegisterText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/requirements/REPORT-DEFINITIONS.md')
foreach ($forbiddenReportMapping in @('REP-03[^\r\n]*REP-07', '6\.2[^\r\n]*REP-04')) {
    if ($reportRegisterText -match $forbiddenReportMapping) {
        Add-Failure "Report register contains forbidden operational/report dual mapping: $forbiddenReportMapping"
    }
}
if ($reportRegisterText -notmatch 'REP-07 only' -or $reportRegisterText -notmatch 'Apache POI') {
    Add-Failure 'Report register must separate REP-07 outcomes and keep export libraries blocked.'
}
if ($reportRegisterText -notmatch 'NO_PARTIAL_MAPPING_FROM_SECTION_6_4_TO_REP_02') {
    Add-Failure 'REP-02 must explicitly reject any complete or partial mapping from contract section 6.4.'
}

$manifestText = Get-Content -Raw -Encoding utf8 -LiteralPath $documentManifest
if ($manifestText -match 'path_prefix:\s*\.\./requirements/') {
    Add-Failure 'Broad requirements/ manifest prefix is forbidden; active registers require unambiguous exact entries.'
}
$withdrawnHistoricalArtifacts = @(
    'docs/phase-scope/phases/phase-1/11_Phase_1_Evidence_Matrix.md',
    'docs/phase-scope/phases/phase-1/20_Phase_1_Baseline_Definitions.md',
    'docs/phase-scope/source-audit/16_Previous_Questions_Source_Resolution.md',
    'docs/phase-scope/phases/phase-2/18_Phase_1_vs_Phase_2_Differential.md',
    'docs/phase-scope/phases/phase-1/24_Phase_1_Financial_Boundary.md',
    'docs/phase-scope/decisions/client/21_Client_Clarifications_Phase_1.md',
    'docs/phase-scope/decisions/client/21_Client_Clarifications_Phase_1_HY.md',
    'docs/phase-scope/decisions/09_Decision_Log.md',
    'docs/phase-scope/decisions/17_Questions_Only_After_Source_Audit.md',
    'docs/phase-scope/decisions/client/31_Client_Approval_Package_Phase_1.md',
    'docs/phase-scope/phases/phase-2/12_Phase_2_Evidence_Matrix.md',
    'docs/phase-scope/phases/phase-3/13_Phase_3_Evidence_Matrix.md',
    'docs/phase-scope/decisions/client/23_Template_Content_Commercial_Boundary.md',
    'docs/phase-scope/phases/phase-1/22_Phase_1_Report_Register.md',
    'docs/phase-scope/decisions/client/31_Client_Approval_Package_Phase_1_HY.md',
    'docs/phase-scope/source-audit/10_Source_Audit_Method.md',
    'docs/phase-scope/source-audit/15_Confirmed_Conflicts_and_Gaps.md',
    'docs/phase-scope/source-audit/19_Ambiguous_First_Phase_Phrases.md',
    'docs/phase-scope/cross-cutting/14_Cross_Cutting_Evidence.md',
    'docs/phase-scope/archive/initial-drafts/07_Internal_Questions.md',
    'docs/phase-scope/archive/initial-drafts/08_Client_Agreement_Checklist.md',
    'docs/phase-scope/phases/phase-1/25_Phase_1_Data_Migration_Boundary.md',
    'docs/phase-scope/phases/phase-1/26_Phase_1_Infrastructure_NFR_Boundary.md',
    'docs/phase-scope/phases/phase-1/28_Phase_1_API_Signature_Code_Deliverables_Boundary.md',
    'docs/phase-scope/phases/phase-1/27_Phase_1_Acceptance_Warranty_SLA_Boundary.md',
    'docs/phase-scope/archive/initial-drafts/01_Master_Function_Phase_Matrix.md',
    'docs/phase-scope/archive/initial-drafts/02_Phase_1_In_Scope.md',
    'docs/phase-scope/archive/initial-drafts/03_Phase_1_Exclusions.md',
    'docs/phase-scope/archive/initial-drafts/04_Phase_2_Scope.md',
    'docs/phase-scope/archive/initial-drafts/05_Phase_3_Scope.md',
    'docs/phase-scope/archive/initial-drafts/06_Integration_Boundaries.md'
)
foreach ($relativeHistoricalPath in $withdrawnHistoricalArtifacts) {
    $historicalPath = Join-Path $RepositoryRoot $relativeHistoricalPath
    if (-not (Test-Path -LiteralPath $historicalPath)) {
        Add-Failure "Withdrawn historical stub is missing: $relativeHistoricalPath"
        continue
    }
    $historicalText = Get-Content -Raw -Encoding utf8 -LiteralPath $historicalPath
    $historicalLineCount = (Get-Content -Encoding utf8 -LiteralPath $historicalPath).Count
    if ($historicalText -notmatch 'WITHDRAWN_FROM_ACTIVE_DOCUMENTATION_SURFACE' -or $historicalText -notmatch 'NON_AUTHORIZING') {
        Add-Failure "Historical artifact lacks the withdrawn/non-authorizing marker: $relativeHistoricalPath"
    }
    if ($historicalLineCount -gt 15 -or $historicalText -match '(?m)^\|.*\|\s*$') {
        Add-Failure "Historical artifact must remain a short, table-free redirect stub: $relativeHistoricalPath"
    }
}

# D-008 has one canonical task class and an explicit template applicability profile.
$gateText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/00-IMPLEMENTATION-GATE.md')
$taskTemplateText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/governance/TASK-GO-TEMPLATE.md')
if ($gateText -notmatch 'D008_COMPATIBILITY_POC' -or $gateText -notmatch 'PRODUCTION_PILOT_RELEASE') {
    Add-Failure 'Gate must distinguish the D-008 task class from the production pilot-release task class.'
}
foreach ($requiredD008Token in @(
    'D008_COMPATIBILITY_POC',
    'N/A_D008',
    'TECHNICAL_POC',
    'DISPOSABLE_D008_POC',
    'N/A_D008_SPEC_PRESCRIBED',
    'N/A_D008_PRE_ADR_EVIDENCE',
    'N/A_D008_NO_BUSINESS_OR_PATIENT_DATA',
    'NONE_D008',
    'N/A_D008_NON_BUSINESS',
    'PENDING_D008_EXECUTION',
    'D-008 compatibility run record path'
)) {
    if ($taskTemplateText -notmatch [regex]::Escape($requiredD008Token)) {
        Add-Failure "TASK-GO-TEMPLATE is missing D-008 profile token: $requiredD008Token"
    }
}
if ($taskTemplateText -notmatch 'optional independent-review record' -or
    $taskTemplateText -notmatch 'Contract signature verification') {
    Add-Failure 'TASK-GO-TEMPLATE must define TASK-GO as optional and signature-independent.'
}
foreach ($requiredIdentifierExemption in @('pilot/openmrs-compatibility/', 'saribekyanpilot', 'org.openmrs.module.saribekyanpilot', 'saribekyan-pilot-extension')) {
    if ($gateText -notmatch [regex]::Escape($requiredIdentifierExemption)) {
        Add-Failure "Gate must preserve required disposable pilot identifier: $requiredIdentifierExemption"
    }
}

# The D-008 documentation directory must never become a second PoC workspace.
$forbiddenDocsPilotWorkspace = Join-Path $RepositoryRoot 'docs/pilot/openmrs-compatibility'
if (Test-Path -LiteralPath $forbiddenDocsPilotWorkspace) {
    Add-Failure 'Forbidden duplicate D-008 workspace under docs/pilot; use repository-root pilot/openmrs-compatibility/.'
}
$pocSpecText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/pilot/COMPATIBILITY-POC.md')
foreach ($requiredPathRule in @('<REPOSITORY_ROOT>/pilot/openmrs-compatibility/', 'docs/pilot/openmrs-compatibility/')) {
    if ($pocSpecText -notmatch [regex]::Escape($requiredPathRule)) {
        Add-Failure "Compatibility spec is missing canonical/forbidden workspace rule: $requiredPathRule"
    }
}
foreach ($requiredCheckpointRule in @(
    'KICKOFF_READY',
    'COMPLETION_REVIEW',
    'PENDING_D008_EXECUTION',
    'Pre-code inputs',
    'Post-run outputs',
    'actual full 40-hex commit SHA',
    'Effective distro/SPA overlay diff',
    'Executed commands and check results',
    'Result and blockers',
    'N/A_FIRST_ATTEMPT',
    'Attempt number (positive integer'
)) {
    if ($pocSpecText -notmatch [regex]::Escape($requiredCheckpointRule)) {
        Add-Failure "Compatibility spec is missing D-008 checkpoint rule: $requiredCheckpointRule"
    }
}
if ($taskTemplateText -notmatch 'KICKOFF_REVIEW' -or $taskTemplateText -notmatch 'Post-run completion review') {
    Add-Failure 'TASK-GO-TEMPLATE must separate optional D-008 kickoff review from completion evidence.'
}

# Interpretation guards stay in governance. They are not inserted into the contractual TA.
if ($gateText -notmatch 'NO_FINANCIAL_STATUS_INFERENCE') {
    Add-Failure 'Gate must reject inferring a clinical gate from financial status.'
}
if ($reportRegisterText -notmatch 'NO_FORMULA_FROM_REPORT_LABEL') {
    Add-Failure 'Report register must reject formulas inferred from a report label.'
}

$databaseText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/05-DATABASE.md')
$glossaryText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/requirements/GLOSSARY.md')
if ($databaseText -notmatch 'NO_VISIT_EQUALS_INPATIENT_CASE' -or $glossaryText -notmatch 'NO_VISIT_EQUALS_INPATIENT_CASE') {
    Add-Failure 'Visit/Encounter documentation must not imply an inpatient-case model.'
}
if ($databaseText -notmatch 'NO_RESULT_MODEL_FROM_CANDIDATE_MAPPING') {
    Add-Failure 'Database mapping must not select a result model or FHIR mapping from candidate names.'
}

$structureText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/03-STRUCTURE.md')
if ($structureText -notmatch 'placeholder repository tree' -or $structureText -match '<future-repository-root>') {
    Add-Failure 'Structure guidance must not prescribe a speculative repository tree.'
}

$apiText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/04-API.md')
if ($apiText -match '\| Custom `/api/v1/\.\.\.` facade \|') {
    Add-Failure 'API guidance must not present a custom /api/v1 facade as a predefined surface.'
}
if ($apiText -notmatch 'API_CHECKLIST_NOT_FACADE_CONTRACT') {
    Add-Failure 'API guidance must remain a decision checklist, not a ready facade/correlation contract.'
}

$techCardText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/TECH_CARD.md')
if ($techCardText -match '\| Business boundaries \|[^\r\n]*\| Approved Phase I ownership map \|' -or
    $techCardText -match '\| Custom Java finance OMOD \|') {
    Add-Failure 'TECH_CARD must not turn ownership groups or finance gaps into OMOD instructions.'
}

if ($pocSpecText -notmatch 'D008_SUCCESS_OR_TERMINAL_EVIDENCE') {
    Add-Failure 'D-008 proof section must explicitly accept terminal incompatibility evidence without workaround.'
}

$taskGoReviewerPath = Join-Path $RepositoryRoot '.cursor/agents/task-go-reviewer.md'
if (-not (Test-Path -LiteralPath $taskGoReviewerPath)) {
    Add-Failure 'Missing independent task-go-reviewer agent definition.'
} else {
    $taskGoReviewerText = Get-Content -Raw -Encoding utf8 -LiteralPath $taskGoReviewerPath
    foreach ($requiredReviewerRule in @(
        'KICKOFF_REVIEW',
        'COMPLETION_REVIEW',
        'PHASE-1-TRACEABILITY.md',
        'DOCUMENT-MANIFEST.yaml',
        'independent dependency inventory',
        'actual repository diff',
        'affected_files',
        'NO_GO',
        'D008_SUCCESS_OR_TERMINAL_EVIDENCE'
    )) {
        if ($taskGoReviewerText -notmatch [regex]::Escape($requiredReviewerRule)) {
            Add-Failure "Task-go reviewer is missing hardened review rule: $requiredReviewerRule"
        }
    }
}

if ($taskTemplateText -notmatch 'review_checkpoint:\s*KICKOFF_REVIEW' -or
    $taskTemplateText -notmatch 'COMPLETION_REVIEW') {
    Add-Failure 'TASK-GO template must declare kickoff and completion review checkpoints.'
}

# Retained sources stay in the repository. Authority is corrected in place; deletion is not the control.
$visionCandidates = @(Get-ChildItem -LiteralPath $RepositoryRoot -File -Filter '*.docx.md')
if ($visionCandidates.Count -ne 1) {
    Add-Failure 'Expected exactly one retained root vision file.'
    $visionPath = $null
} else {
    $visionPath = $visionCandidates[0].FullName
}
if ($visionPath) {
    $visionText = Get-Content -Raw -Encoding utf8 -LiteralPath $visionPath
    $visionLineCount = (Get-Content -Encoding utf8 -LiteralPath $visionPath).Count
    if ($visionText -notmatch 'RETAINED_HISTORICAL_VISION_BODY_NOT_PHASE_I_SCOPE' -or $visionLineCount -lt 1000) {
        Add-Failure 'The root vision body must stay retained and must not be reduced to a redirect stub.'
    }
    $visionAuditText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/source-audit/SOURCE-AUDIT-MANIFEST.yaml')
    $visionAuditHash = [regex]::Match($visionAuditText, 'current_sha256:\s*([A-Fa-f0-9]{64})')
    $visionActualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $visionPath).Hash
    if (-not $visionAuditHash.Success -or $visionAuditHash.Groups[1].Value.ToUpperInvariant() -ne $visionActualHash) {
        Add-Failure 'SOURCE-AUDIT-MANIFEST current_sha256 must match the retained vision file.'
    }
}

foreach ($retainedContractFile in @(
    'docs/techHistory/phase-1/Phase_1_Technical_Specification_HY.md',
    'docs/techHistory/phase-1/Phase_1_Technical_Specification_HY.docx',
    'docs/techHistory/phase-1/Phase_1_Technical_Specification_HY.pdf',
    'docs/techHistory/phase-1/Phase_1_Technical_Specification_HY_signed.jpg',
    'docs/techHistory/phase-1/Phase_1_Technical_Specification_Legal_Review_Recommendations_RU.md'
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $retainedContractFile))) {
        Add-Failure "Retained contract artifact is missing: $retainedContractFile"
    }
}
if ($signatureText -notmatch 'STALE_REGENERATE_REQUIRED' -or $signatureText -notmatch 'Deleting them is not a parity correction') {
    Add-Failure 'Stale DOCX/PDF must remain declared and must not be treated as deleted.'
}

$contractText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/techHistory/phase-1/Phase_1_Technical_Specification_HY.md')
foreach ($lifecycleId in @('AMB-13', 'DIA-03', 'LAB-03', 'RAD-01', 'FDI-01')) {
    if ($contractText -notmatch ('(?m)^\| ' + [regex]::Escape($lifecycleId) + ' \|[^\r\n]*NO_ENUM_FROM_THIS_LIST')) {
        Add-Failure "Contract lifecycle row must reject enum inference: $lifecycleId"
    }
}

$closedDecisionLabel = -join (@(0x0531, 0x0574, 0x0580, 0x0561, 0x0563, 0x0580, 0x0578, 0x0582, 0x0574) | ForEach-Object { [char]$_ })
if ($clarification32Text -notmatch 'NO_DRAFT_RESOLUTION_AS_DECISION_SOURCE' -or
    $clarification32Text.Contains('**' + $closedDecisionLabel) -or
    $clarification32Text -notmatch '### C-01' -or
    $clarification32Text -notmatch '### C-31' -or
    (Get-Content -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/decisions/client/32_Client_Clarifications_Resolution_Phase_1_HY.md')).Count -lt 100) {
    Add-Failure 'Clarification 32 must remain a retained draft and must not read as a closed decision register.'
}

$moduleMatrixText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/requirements/MODULE-SOURCE-MATRIX.md')
if ($moduleMatrixText -notmatch 'NO_ARTIFACT_FROM_MAPPING' -or
    $moduleMatrixText -match 'Custom Java OMOD|Custom O3 UI|Proposed custom|High custom risk|Proposed mapping') {
    Add-Failure 'Module source matrix must remain a gap inventory and must not prescribe an artifact or layer.'
}

$phaseScopeIndexText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/00_README.md')
if ($phaseScopeIndexText -notmatch 'HISTORICAL_NAVIGATION_ONLY' -or
    $phaseScopeIndexText -notmatch 'NO_NATURAL_DETAIL_AUTHORIZATION' -or
    $phaseScopeIndexText -notmatch 'historical paths;') {
    Add-Failure 'The phase-scope index must stay navigation-only and must not authorize natural-detail inference.'
}
$archiveIndexText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/archive/initial-drafts/README.md')
if ($archiveIndexText -notmatch 'NO_CURRENT_PRIORITY_SOURCES' -or
    $archiveIndexText -notmatch 'NON_AUTHORIZING' -or
    $archiveIndexText -notmatch 'NO_CLOSED_CLARIFICATION_CLAIM') {
    Add-Failure 'The archived-drafts index must not promote any archived artifact or draft 32 as a current source.'
}

# Option A/as-built documentation must remain internally aligned.
$governanceReadmeText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/governance/README.md')
foreach ($canonicalStatus in @(
    'ACCEPTED_AS_BUILT',
    'ACCEPTED_AS_BUILT_PARTIAL',
    'AS_BUILT_FOUNDATION',
    'ACTIVE_DELIVERY_BASELINE',
    'OWNER_AUTHORIZED_BASELINE',
    'APPROVED_CONSTRAINT',
    'GOVERNING_GUARDRAIL_NO_GO',
    'BLOCKED_FOR_DEPENDENT_INFRASTRUCTURE_ONLY',
    'OUT_OF_SCOPE'
)) {
    if ($governanceReadmeText -notmatch [regex]::Escape($canonicalStatus)) {
        Add-Failure "Governance lifecycle dictionary is missing an in-use status: $canonicalStatus"
    }
}

$techCardText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/TECH_CARD.md')
foreach ($obsoleteTechCardStatus in @(
    'ACCEPTED_DIRECTION',
    'BASELINE_V1_3_OWNER_AUTHORIZED',
    'APPROVED_DIRECTION',
    'VALIDATION_REQUIRED',
    'REQUIRED_FOR_CHANGED_ARTIFACTS',
    'REQUIRED_PER_IMPLEMENTED_REQUIREMENT',
    'REQUIRED_FOR_STACK_OR_MIGRATION_CHANGES',
    'GOVERNANCE REQUIREMENT',
    'AS-BUILT DELIVERABLE'
)) {
    if ($techCardText -match [regex]::Escape($obsoleteTechCardStatus)) {
        Add-Failure "TECH_CARD contains a non-canonical status token: $obsoleteTechCardStatus"
    }
}
if ($techCardText -notmatch 'SIGNATURE_IS_LEGAL_METADATA_NOT_CODING_GATE') {
    Add-Failure 'TECH_CARD must identify signature state as legal metadata rather than a coding gate.'
}

$implementationGateText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/00-IMPLEMENTATION-GATE.md')
if ($implementationGateText -match '\| Java package prefix \|' -or
    $implementationGateText -match '\| Pilot stack \|') {
    Add-Failure 'Implementation guidance still contains an obsolete namespace, stack-pin, or signed-TA blocker.'
}

$adrIdentityText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/architecture/ADR-0003-identity-boundary.md')
$clientDecisionIndexText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/phase-scope/decisions/client/README.md')
if ($adrIdentityText -match 'business scope still requires signed TA' -or
    $clientDecisionIndexText -match 'verified signed TA artifact') {
    Add-Failure 'An active guidance file still treats a verified signed TA as a development prerequisite.'
}

$traceabilityText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/requirements/PHASE-1-TRACEABILITY.md')
foreach ($readinessStatus in @('PARTIAL_BLOCKED', 'READY_SLICE_WITH_CONCURRENCY_BLOCKER')) {
    if ($traceabilityText -notmatch "\| ``$readinessStatus`` \|.*\|") {
        Add-Failure "Traceability legend is missing an in-use readiness status: $readinessStatus"
    }
}

$gitignoreText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot '.gitignore')
if ($gitignoreText -notmatch '(?m)^/docs/\.env$' -or
    -not (Test-Path -LiteralPath (Join-Path $RepositoryRoot 'docs/.env.example'))) {
    Add-Failure 'Local docs/.env must be ignored and docs/.env.example must remain as the committed template.'
}

$architectureText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/01-ARCHITECTURE.md')
foreach ($asBuiltArchitectureRule in @(
    'O3 app shell | Navigation, localization, extensions, shared UI | ACCEPTED_AS_BUILT',
    'Reused O3 modules',
    'ACCEPTED_AS_BUILT_PARTIAL',
    'openmrs-module-saribekyan'
)) {
    if ($architectureText -notmatch [regex]::Escape($asBuiltArchitectureRule)) {
        Add-Failure "Architecture is missing as-built evidence/status: $asBuiltArchitectureRule"
    }
}

$phaseStatusText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot 'docs/governance/PHASE-STATUS.yaml')
if ($phaseStatusText -notmatch 'active_phases:\s*\[P0, P2\]' -or
    $phaseStatusText -notmatch 'REG-02 patient-search partial slice' -or
    $phaseStatusText -match 'REG-01/REG-02 partial slice') {
    Add-Failure 'Phase status must record the early REG-02 slice alongside unfinished P0 without claiming REG-01.'
}

foreach ($deliveryDoc in @(
    'docs/08-TESTING-AND-UAT.md',
    'docs/09-OPERATIONS-AND-RELEASE.md',
    'docs/modules/SARIBEKYAN-OMOD.md'
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $deliveryDoc))) {
        Add-Failure "Missing active delivery/as-built document: $deliveryDoc"
    }
}

foreach ($obsoleteGateToken in @('READY_FOR_TASK_GO', 'AWAITING_TASK_GO', 'REQUIRES_TASK_GO_EVIDENCE')) {
    foreach ($activeRegister in @(
        'docs/requirements/PHASE-1-TRACEABILITY.md',
        'docs/governance/DOCUMENT-MANIFEST.yaml'
    )) {
        $activeRegisterText = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $RepositoryRoot $activeRegister)
        if ($activeRegisterText -match [regex]::Escape($obsoleteGateToken)) {
            Add-Failure "Obsolete mandatory TASK-GO token remains in ${activeRegister}: $obsoleteGateToken"
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'Structural documentation governance checks passed.'
if ($readinessIssues.Count -gt 0) {
    Write-Output 'Contract signing readiness: NOT_READY'
    $readinessIssues | ForEach-Object { Write-Output "- $_" }
    if ($RequireSigningReady) { exit 2 }
} else {
    Write-Output 'Contract signing readiness: READY_FOR_REVIEW'
}
