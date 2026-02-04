#!/usr/bin/env pwsh
function Get-FederatedToken {
    param(
        [string]$Audience
    )
    $runtimeUrl = [System.Environment]::GetEnvironmentVariable('ACTIONS_ID_TOKEN_REQUEST_URL')
    if ($Audience) {
        $encodedAudience = [System.Web.HttpUtility]::UrlEncode($Audience)
        $runtimeUrl = "$runtimeUrl&audience=$encodedAudience"
    }
    $requestToken = [System.Environment]::GetEnvironmentVariable('ACTIONS_ID_TOKEN_REQUEST_TOKEN')
    $token = Invoke-RestMethod -Method Get -Uri $runtimeUrl -UserAgent 'actions/oidc-client' -Headers @{ Authorization = "Bearer $requestToken" }
    if ($token.value) {
        return $token.value
    }
    else {
        throw 'Failed to retrieve federated token.'
    }
}

function Get-AzAuthParameters {
    param(
        [string]$ClientId,
        [string]$TenantId,
        [string]$Environment = 'AzureCloud',
        [string]$SubscriptionId,
        [string]$Audience = 'api://AzureADTokenExchange',
        [string]$AuthType = 'SERVICE_PRINCIPAL'

    )
    
    $azAuthParameters = @{
        ApplicationId     = $ClientId
        FederatedToken    = Get-FederatedToken -Audience $Audience
        Environment       = $Environment
        InformationAction = 'Ignore'
    }

    if ($TenantId) {
        $azAuthParameters.Add('Tenant', $TenantId)
    }

    if ($SubscriptionId) {
        $azAuthParameters.Add('Subscription', $SubscriptionId)
    }

    if ($AuthType -eq 'SERVICE_PRINCIPAL') {
        $azAuthParameters.Add('ServicePrincipal', $true)
    } 
    else {
        $azAuthParameters.Add('Identity', $true)
    }
    return $azAuthParameters
}

$WarningPreference = 'SilentlyContinue'
Import-Module -Name 'Az.Accounts', 'Az.PolicyInsights','EnterprisePolicyAsCode' -ErrorAction Stop
$azAuthParameters = Get-AzAuthParameters -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID
$null = Connect-AzAccount @azAuthParameters
$WarningPreference = 'Continue'