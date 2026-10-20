param(
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
)

$ErrorActionPreference = 'Stop'
$failures = [System.Collections.Generic.List[string]]::new()

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

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'Documentation governance checks passed.'
