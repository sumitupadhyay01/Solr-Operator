[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $acrName = "sugacr",
    [Parameter()]
    [String]
    $rgname = "sug-acr",
    [Parameter()]
    [String]
    $location = "westeurope"
)

Write-Host ""
Write-Host "starting registry infra deployment..." -ForegroundColor Yellow;

$deployname = "deploy-$acrname-registry";

Write-Host "";
Write-Host "using parameters:";
Write-Host "---------------------------------";
Write-Host " -> rgname [$rgname]";
Write-Host " -> location [$location]";
Write-Host " -> deployname [$deployname]";
Write-Host "---------------------------------";
Read-Host "to cancel hit [ctrl]+[c]... to continu hit [enter]...";

Write-Host "";
Write-Host "create resourcegroup [$rgname]";
az group create -l $location -n $rgname


Write-Host "";
Write-Host "starting deployment [$deployname] on resourcegroup [$rgname]";
az deployment group create -g $rgname -n $deployname `
    --verbose `
    --template-file .\azure\registry.json `
    --parameters acrName=$acrname
