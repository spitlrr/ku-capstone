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
$VarsFile = Join-Path $PackerDir "local.auto.pkrvars.hcl"

function Test-BuildVars {
    if (-not (Test-Path $VarsFile)) {
        Write-Host "Missing: $VarsFile"
        Write-Host "Create it from local.auto.pkrvars.example.hcl first"
        exit 1
    }
}

function Invoke-Build {
    Test-BuildVars
    Set-Location $PackerDir
    packer build .\rocky9.pkr.hcl

}

function Invoke-Up {
    if (-not (Test-Path $BoxFile)) {
        Write-Host "Box not found: $BoxFile"
        Write-Host "Run the build command first to create the box."
        exit 1
    }

    Set-Location $RepoRoot
    vagrant box add --name $BoxName --provider virtualbox $BoxFile --force

    Set-Location $VagrantDir
    vagrant destroy -f
    vagrant up --provider=virtualbox
}

function Invoke-Login {
    Set-Location $VagrantDir
    vagrant ssh-config > ssh-config
    ssh -t -F .\ssh-config default "sudo -iu capstone bash --login"
}

switch ($Mode) {
    "build" { Invoke-Build }
    "up" { Invoke-Up }
    "login" { Invoke-Login }
    "all" {
        Invoke-Build
        Invoke-Up
        Invoke-Login
        }
}