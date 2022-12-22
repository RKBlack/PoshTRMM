<#
.SYNOPSIS
    Gets a list of software from Tactical RMM
.DESCRIPTION
    The Get-SoftwareFromTRMM cmdlet gets a list of software sotred in the Tactical RMM database.
    You can direct this cmdlet to get software from only specific clients with the -Clients parameter
.PARAMETER Clients
    Comma separated list of clients.  Pipeline input supported.
.EXAMPLE
    C:\PS> Get-SoftwareFromTRMM -Clients 'ACME Inc','Contoso','Some Other Client Name'
.NOTES
    Author: Justin Bloomfield
    Date:   November 29, 2022
#>
function Get-SoftwareFromTRMM {
    param (
        [Parameter(ValuefromPipeline = $True)]
        [string[]]
        $Clients
    )

    $agentsResult = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object {
        if ($Clients) {
            $_.client_name -in $Clients
        }
        else {
            $true
        }
    }
    $softwareList = @()
    foreach ($agent in $agentsResult) {
        $softwareResult = (Invoke-TrmmRequest -Method 'Get' -Resource "/software/$($agent.agent_id)/") 
        foreach ($softwareName in $softwareResult.software) {
            $softObj = New-Object psobject -Property @{
                'Computer'     = [string]$agent.hostname
                'Name'         = [string]$softwareName.name
                'Publisher'    = [string]$softwareName.Publisher
                'Installed On' = [datetime]$softwareName.install_date
                'Size'         = $softwareName.Size
                'Version'      = $softwareName.Version
                'Source'       = $($softwareName.source).Replace('\\', '\')
                'Location'     = $($softwareName.location).Replace('\\', '\')
                'Uninstall'    = $($softwareName.uninstall).Replace('\\', '\')
            }
            $softwareList += $softObj
        }
    }
    return $softwareList
}
