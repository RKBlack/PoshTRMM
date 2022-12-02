<#
.SYNOPSIS
    Gets a list of windows updates from Tactical RMM agents
.DESCRIPTION
    The Get-WindowsUpdatesFromTRMM cmdlet gets a list of windows updates from Tactical RMM agents. 
    By default the output groups by agent and only displays updates that are not installed.  Use the -ShowInstalled switch to 
    display previously installed updates. Use -Raw to remove grouping and output all available data.
.PARAMETER Clients
    Comma separated list of clients.  Pipeline input supported.
.PARAMETER ShowInstalled
    Switch to enable the display of previously installed updates
.PARAMETER Raw
    Switch to output raw data without filters or grouping
.EXAMPLE
    Get-SoftwareFromTRMM -Clients 'ACME Inc.' -ShowInstalled

.NOTES
    Author: Justin Bloomfield
    Date:   December 2, 2022    
#>
function Get-WindowsUpdatesFromTRMM {
    param (
        [Parameter(ValuefromPipeline = $True)]
        [string[]]
        $Clients,
        [switch]
        $ShowInstalled,
        [switch]
        $Raw
    )

    $agentsResult = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object {
        if ($Clients) {
            $_.client_name -in $Clients
        }
        else {
            $true
        }
    }
    $updatesList = @()
    foreach ($agent in $agentsResult) {
        $updatesResult = (Invoke-TrmmRequest -Method 'Get' -Resource "/winupdate/$($agent.agent_id)/") 
        foreach ($winupdate in $updatesResult) {
            $updObj = New-Object psobject -Property @{
                'Computer'       = [string]$agent.hostname
                'KB'             = [string]$winupdate.kb
                'Title'          = [string]$winupdate.title
                'Installed'      = [bool]$winupdate.installed
                'Downloaded'     = [bool]$winupdate.downloaded
                'Description'    = [string]$winupdate.Description
                'Severity'       = [string]$winupdate.severity
                'Categories'     = [string[]]$winupdate.categories
                'Category IDs'   = [string[]]$winupdate.category_ids
                'KB Article IDs' = [string[]]$winupdate.kb_article_ids
                'More Info URLs' = [string[]]$winupdate.more_info_urls
                'Support URL'    = [string]$winupdate.support_url
            }
            if ($ShowInstalled) {
                $updatesList += $updObj
            } else {
                if (!($winupdate.installed)) {$updatesList += $updObj}
            }
        }
    }
    if ($Raw) {
        return $updatesList
    } else {
        return $updatesList | Format-Table Computer,KB,Title,Installed,Downloaded,Severity -GroupBy Computer
    }

}