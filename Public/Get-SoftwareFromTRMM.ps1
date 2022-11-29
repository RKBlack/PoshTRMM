<#
.SYNOPSIS
    Gets a list of software from Tactical RMM
.DESCRIPTION
    The Get-SoftwareFromTRMM cmdlet gets a list of software sotred in the Tactical RMM database.
    You can direct this cmdlet to get software from only specific clients with the -ClientFilter parameter
.PARAMETER TRMMApiKey
    API Key from Settings > Global Settings > API Keys
.PARAMETER TRMMApiUrl
    Base url for the Tactical RMM API
.PARAMETER ClientFilter
    Comma separated list of clients
.EXAMPLE
    C:\PS> Get-SoftwareFromTRMM -TRMMApiKey 'ABCDEF123456789' -TRMMApiUrl 'https://api.example.com' -ClientFilter 'ACME Inc','Contoso','Some Other Client Name'
.NOTES
    Author: Justin Bloomfield
    Date:   November 29, 2022    
#>
function Get-SoftwareFromTRMM {
    param (
        [Parameter(Mandatory)]
        [string]
        $TRMMApiKey,
        [Parameter(Mandatory)]
        [string]
        $TRMMApiUrl,
        [string[]]
        $ClientFilter
    )

    $headers = @{
        'X-API-KEY' = $TRMMApiKey
    }

    $url = $TRMMApiUrl
    $agentsResult = (Invoke-RestMethod -Method 'Get' -Uri "$url/agents/" -Headers $headers -ContentType 'application/json') | Where-Object {
        if ($clientFilter) {
            $_.client_name -in $clientFilter
        }
        else {
            $true
        }
    }
    $softwareList = @()
    foreach ($agent in $agentsResult) {
        $softwareResult = (Invoke-RestMethod -Method 'Get' -Uri "$url/software/$($agent.agent_id)/" -Headers $headers -ContentType 'application/json') 
        foreach ($softwareName in $softwareResult.software) {
            $softObj = New-Object psobject -Property @{
                Computer = $agent.hostname
                Software = $softwareName.name
            }
            $softwareList += $softObj
        }
    }
    return $softwareList
}
