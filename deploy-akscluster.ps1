[CmdletBinding()]
param (
    [Parameter()]
    [String]
    [ValidateSet('nonprd','prd')]
    $env,
    [Parameter()]
    [String]
    $prefix = "sug-$env",
    [Parameter()]
    [String]
    $rgname = "$($prefix)-infra",
    [Parameter()]
    [String]
    $location = "westeurope",
    [Parameter()]
    [String]
    $acrname = "sugacr"
)

Write-Host ""
Write-Host "starting aks cluster infra deployment..." -ForegroundColor Yellow;

$deployname = "$prefix-cluster-infra";
$aksname = "$prefix-aks";

Write-Host "";
Write-Host "using parameters:";
Write-Host "---------------------------------";
Write-Host " -> rgname [$rgname]";
Write-Host " -> prefix [$prefix]";
Write-Host " -> location [$location]";
Write-Host " -> deployname [$deployname]";
Write-Host " -> acrname [$acrname]";
Write-Host " -> aksname [$aksname]";
Write-Host "---------------------------------";
Read-Host "to cancel hit [ctrl]+[c]... to continu hit [enter]...";

Write-Host "";
Write-Host "create resourcegroup [$rgname]";
az group create -l $location -n $rgname


Write-Host "";
Write-Host "starting deployment [$deployname] on resourcegroup [$rgname]";
az deployment group create -g $rgname -n $deployname `
    --verbose `
    --template-file .\azure\cluster\azuredeploy.json `
    --parameters .\azure\cluster\azuredeploy.parameters.$($env).json `
    --parameters prefix=$prefix aksName=$aksName

Write-Host "";
Write-Host "attach Azure Container Registry [$acrname] to AKS Cluster [$aksname] on resourcegroup [$rgname]";
az aks update -n $aksname -g $rgname --attach-acr $acrname

