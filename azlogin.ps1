[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $tenantid = "",  
    [Parameter()]
    [String]
    $subscriptionid = "", 
    [Parameter()]
    [Switch]
    $reconnect #switch to force reconnect in any case
)

function getAzStatus{
    $azStatus = $null;

    try {
        $azStatus = ($(az account show) | ConvertFrom-Json);
    }
    catch {
        Write-Host "Unable to retreive az status through 'az account show'" -ForegroundColor Blue;
        $azStatus = $null;
    }

    return $azStatus
}

Write-Host ""
Write-Host "handle az cli login..."  -ForegroundColor Yellow;

$azStatus = getAzStatus;
if($azStatus.tenantId -ne $tenantid -or $reconnect){
    Write-Host "Login to Tenant with id [$tenantid]";
    az login -t $tenantid
    $azStatus = getAzStatus;
}

if($azStatus.id -ne $subscriptionid -or $reconnect){
    Write-Host "Login to Subscription with id [$subscriptionid]";
    az account set -s $subscriptionid
    $azStatus = getAzStatus;
}

if($null -eq $azStatus){
    Write-Host "AZ CLI Login Failed" -ForegroundColor Blue
    exit 1;
}

Write-Host "status overview";
Write-Host "---------------------------------";
$azStatus | ConvertTo-Json
Write-Host "---------------------------------";


if($azStatus.tenantId -ne $tenantid -or $azStatus.id -ne $subscriptionid){
    Write-Host "AZ CLI Context Invalid" -ForegroundColor Blue
    Write-Host "Should be logged in to Subscription [$subscriptionid] on Tenant [$tenantid]" -ForegroundColor Blue
    exit 1;
}

Write-Host "az cli login is successfull" -ForegroundColor Yellow
Write-Host ""
