function Get-TrmmAgents {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $Clients,
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $AgentNames,
        [ValidateSet('Workstation', 'Server')]
        [string]
        $AgentType
    )

    $agents = @()

    if ($AgentNames) {
        foreach ($agentName in $AgentNames) {            
            if ($AgentType) {
                $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.hostname -eq $agentName -and $_.monitoring_type -eq $AgentType }
            }
            else {
                $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.hostname -eq $agentName }
            }
            $agents += $filteredAgents
        }
    }
    elseif ($Clients) {
        foreach ($client in $Clients) {     
            if ($AgentType) {
                $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.client_name -eq $client -and $_.monitoring_type -eq $AgentType }
            }
            else {
                $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.client_name -eq $client }
            }
            $agents += $filteredAgents
        }
    }
    else {  
        if ($AgentType) {
            $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/') | Where-Object { $_.monitoring_type -eq $AgentType }
        }
        else {
            $filteredAgents = (Invoke-TrmmRequest -Method 'Get' -Resource '/agents/')
        }
        $agents += $filteredAgents
    }

    return $agents
}
