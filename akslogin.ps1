[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $aksname,
    [Parameter()]
    [String]
    $aksrgname,
    [Parameter()]
    [String]
    $kubeconfigfile = "$($env:KUBECONFIG)"
)

function getKubectlCurrentContext{
    $context = $null;

    try {
        $context = $(kubectl config current-context).ToString().Trim();
    }
    catch {
        Write-Host "Unable to retreive kubectl context name through 'kubectl config current-context'" -ForegroundColor Blue;
        $context = $null;
    }

    return $context
}

Write-Host ""
Write-Host "handle az aks get-credentials..."  -ForegroundColor Yellow;

$kubeconfigfile = $kubeconfigfile.Replace("\", "\\"); #double slash workaround fixing issue while merging configs (Merged "..." as current context in C)
Write-Host " -> kube config file [$kubeconfigfile]";


$currentCluser = getKubectlCurrentContext;

if($currentCluser -ne $aksname){
    Write-Host "Get credentials for cluster [$aksname]";
    az aks get-credentials -n $aksname -g $aksrgname --overwrite-existing --file $kubeconfigfile
    $currentCluser = getKubectlCurrentContext;
}

if($currentCluser -ne $aksname){
    Write-Host "Kubectl not connected to cluser [$aksname]" -ForegroundColor Blue
    exit 1;
}