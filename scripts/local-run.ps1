param (
    [ValidateSet("all", "build", "up", "login")]
    [string] $Mode = "all"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Join-Path -Parent $PSScriptRoot
$PackerDir = Join-Path $RepoRoot "packer"
$VagrantDir = Join-Path $RepoRoot "vagrant"
$BoxName = "rocky-base-v2.1"
$BoxFile = Join-Path $PackerDir "rocky-base-v2.1.box"

function Invoke-Build {
    Write-Host "Initializing and building Packer template..." -ForegroundColor Cyan
    Set-Location $PackerDir
    packer init .\rocky9.pkr.hcl
    packer build .\rocky9.pkr.hcl
}

function Invoke-Up {
    if (-not (Test-Path $BoxFile)) {
        Write-Error "Box file not found at $BoxFile"
    }

    Set-Location $RepoRoot
    Write-Host "Updating Vagrant box..." -ForegroundColor Cyan
    vagrant box add --name $BoxName --provider virtualbox $BoxFile --force

    Set-Location $VagrantDir
    Write-Host "Rebuilding VM..." -ForegroundColor Cyan
    vagrant destroy -f
    vagrant up --provider=virtualbox
}

function Invoke-Login {
    Set-Location $VagrantDir
    Write-Host "Logging into $BoxName as capstone..." -ForegroundColor Green
    # Connects as vagrant and immediately switches to capstone login shell
    vagrant ssh -- -t "sudo -iu capstone"
}

switch ($Mode) {
    "build" { Invoke-Build }
    "up"    { Invoke-Up }
    "login" { Invoke-Login }
    "all"   {
        Invoke-Build
        Invoke-Up
        Invoke-Login
    }
}