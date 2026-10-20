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

# The signature manifest must remain explicitly unsigned until verified evidence is recorded.
$signatureManifest = Join-Path $RepositoryRoot 'docs/contract/phase-1/SIGNATURE-STATUS.yaml'
if (-not (Test-Path -LiteralPath $signatureManifest)) {
    Add-Failure 'Missing SIGNATURE-STATUS.yaml'
} else {
    $signatureText = Get-Content -Raw -Encoding utf8 -LiteralPath $signatureManifest
    if ($signatureText -match 'authorization_state:\s*SIGNED_VERIFIED' -and
        ($signatureText -match 'signed_artifact:\s*\r?\n\s*path:\s*null' -or
         $signatureText -match 'signed_artifact:[\s\S]*?sha256:\s*null')) {
        Add-Failure 'SIGNED_VERIFIED is invalid while signed artifact path/hash is null.'
    }

    if ($signatureText -notmatch 'authorization_state:\s*SIGNED_VERIFIED') {
        $readinessIssues.Add('Contract authorization state is not SIGNED_VERIFIED.')
    }
    if ($signatureText -notmatch 'business_implementation_authorized:\s*true') {
        $readinessIssues.Add('Business implementation is not authorized.')
    }
    if ($signatureText -match 'parity_with_canonical:\s*(UNVERIFIED|STALE_REGENERATE_REQUIRED)') {
        $readinessIssues.Add('One or more DOCX/PDF renderings are unverified or stale.')
    }
    if ($signatureText -match 'legal_review_required:\s*true') {
        $readinessIssues.Add('Legal review is still required.')
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
if ($workflowText -match '\| Diagnostic order lifecycle \| DIA-01[–-]04 \|') {
    Add-Failure 'DIA-04 must not be classified as part of the diagnostic order lifecycle.'
}
if ($workflowText -match '\| Financial operation \| FIN-03[–-]13 \|') {
    Add-Failure 'Distinct financial operations must not be collapsed into one lifecycle row.'
}
if ($workflowText -notmatch '\| Laboratory specimen lifecycle \| LAB-01 \|') {
    Add-Failure 'LAB-01 specimen lifecycle must have its own blocker row.'
}
if ($workflowText -match '\| Queue/appointment \| REG-04[–-]06 \|') {
    Add-Failure 'REG schedule, appointment, and queue concerns must not be collapsed into one lifecycle row.'
}
if ($workflowText -match '\| Radiology result lifecycle \| RAD-01[–-]03 \|') {
    Add-Failure 'RAD order/execution, result, attachment, and applicability concerns must not be collapsed into one result lifecycle row.'
}
if ($workflowText -notmatch '\| Clinician queue lifecycle \| REG-06 \|') {
    Add-Failure 'REG-06 clinician queue lifecycle must have its own blocker row.'
}
if ($workflowText -notmatch '\| Laboratory result lifecycle \| LAB-03 \|') {
    Add-Failure 'Only LAB-03 may own the laboratory result lifecycle row.'
}
if ($workflowText -match '\| Laboratory result lifecycle \| LAB-02[–-]04 \|') {
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
if ($gateText.Contains('classification-ը պետք է լինի հստակ `pilot`')) {
    Add-Failure 'D-008 classification must not use free-form pilot; use D008_COMPATIBILITY_POC.'
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
if ($taskTemplateText -notmatch 'D008_COMPATIBILITY_POC[^\r\n]*Accepted ADR' -and $taskTemplateText -notmatch 'signed contract or Accepted ADR') {
    Add-Failure 'TASK-GO-TEMPLATE must explicitly exempt D-008 from signed-contract/Accepted-ADR prerequisites.'
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
if ($taskTemplateText -notmatch 'pre-code `GO`' -or $taskTemplateText -notmatch 'Post-run completion review') {
    Add-Failure 'TASK-GO-TEMPLATE must separate D-008 kickoff authorization from completion evidence.'
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'Structural documentation governance checks passed.'
if ($readinessIssues.Count -gt 0) {
    Write-Output 'Signing/implementation readiness: NOT_READY'
    $readinessIssues | ForEach-Object { Write-Output "- $_" }
    if ($RequireSigningReady) { exit 2 }
} else {
    Write-Output 'Signing/implementation readiness: READY_FOR_REVIEW'
}
