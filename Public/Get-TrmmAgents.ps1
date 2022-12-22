<#
.SYNOPSIS
    Gets a list of agents from Tactical RMM
.DESCRIPTION
    The Get-TrmmAgent cmdlet gets a list of agents in the Tactical RMM database.
.PARAMETER Clients
    Comma separated list of clients.  Pipeline input supported.
.PARAMETER AgentNames
    Comma separated list of agent names.  Pipeline input supported.
.PARAMETER AgentType
    Filter agents by type.  Valid values are 'Workstation' and 'Server'.
.EXAMPLE
    C:\PS> Get-TrmmAgents -Clients 'ACME Inc','Contoso','Some Other Client Name'
.NOTES
    Author: Justin Bloomfield
    Date:   December 22, 2020
#>

function Get-TrmmAgents {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, AllowEmptyCollection = $true, PositionalBinding = $false)]
        [string[]]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Client')]
        [string[]]
        $Clients,
        [Parameter(ValueFromPipeline = $true, AllowEmptyCollection = $true, PositionalBinding = $false)]
        [string[]]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('AgentName')]
        [string[]]
        $AgentNames,
        [ValidateSet('Workstation', 'Server')]
        [string]
        $AgentType
    )

    $agents = @()

    if ($AgentNames -and $Clients) {
        Write-Error 'The AgentNames and Clients parameters cannot be used together'
        return
    }

    if ($AgentNames) {
        foreach ($agentName in $AgentNames) {
            $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.hostname -eq $agentName }
            if ($AgentType) {
                $filteredAgents = $filteredAgents | Where-Object { $_.monitoring_type -eq $AgentType }
            }
            $agents += $filteredAgents
        }
    }
    elseif ($Clients) {
        foreach ($client in $Clients) {
            $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.client.name -eq $client }
            if ($AgentType) {
                $filteredAgents = $filteredAgents | Where-Object { $_.monitoring_type -eq $AgentType }
            }
            $agents += $filteredAgents
        }
    }
    else {
        $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/')
        if ($AgentType) {
            $filteredAgents = $filteredAgents | Where-Object { $_.monitoring_type -eq $AgentType }
        }
        $agents += $filteredAgents
    }

    return $agents
}
