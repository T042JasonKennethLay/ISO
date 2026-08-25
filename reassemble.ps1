<#
  Download + reassemble Ubuntu 24.04.1 Live Server ISO from GitHub Release parts.
  Usage (PowerShell):  .\reassemble.ps1
#>
$ErrorActionPreference = 'Stop'

$Tag   = 'v24.04.1'
$Repo  = 'T042JasonKennethLay/ISO'
$Iso   = 'ubuntu-24.04.1-live-server-amd64.iso'
$Base  = "https://github.com/$Repo/releases/download/$Tag"
$Parts = @("$Iso.part00", "$Iso.part01")

Set-Location -Path $PSScriptRoot

function Get-Sha256([string]$Path) {
    (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLower()
}

# Expected hashes, read from the checksum files in this repo
$expected = @{}
foreach ($line in Get-Content 'PARTS.sha256') {
    if ($line -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') { $expected[$Matches[2].Trim()] = $Matches[1].ToLower() }
}
$isoExpected = $null
foreach ($line in Get-Content 'ORIGINAL.sha256') {
    if ($line -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') { $isoExpected = $Matches[1].ToLower() }
}

Write-Host '>> Downloading parts (skipped if already present)...'
foreach ($p in $Parts) {
    if (Test-Path $p) {
        Write-Host "   - $p already here, skipping"
    } else {
        Write-Host "   - fetching $p"
        Invoke-WebRequest -Uri "$Base/$p" -OutFile $p -UseBasicParsing
    }
}

Write-Host '>> Verifying parts...'
foreach ($p in $Parts) {
    $actual = Get-Sha256 $p
    if ($actual -ne $expected[$p]) {
        throw "Checksum mismatch for ${p}: got $actual, expected $($expected[$p]). Delete it and re-run."
    }
    Write-Host "   - $p OK"
}

Write-Host ">> Reassembling into $Iso ..."
$out = [System.IO.File]::Create((Join-Path $PWD $Iso))
try {
    foreach ($p in $Parts) {
        $in = [System.IO.File]::OpenRead((Join-Path $PWD $p))
        try { $in.CopyTo($out, 1MB) } finally { $in.Dispose() }
    }
} finally { $out.Dispose() }

Write-Host '>> Verifying final ISO...'
$actual = Get-Sha256 $Iso
if ($actual -ne $isoExpected) {
    throw "Final ISO checksum mismatch: got $actual, expected $isoExpected"
}

$sizeGB = [math]::Round((Get-Item $Iso).Length / 1GB, 2)
Write-Host ''
Write-Host "OK. $Iso is ready ($sizeGB GB)." -ForegroundColor Green
Write-Host 'Delete the .part00/.part01 files if you no longer need them.'
