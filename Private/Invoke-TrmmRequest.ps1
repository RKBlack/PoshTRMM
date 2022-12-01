function Invoke-TrmmRequest {
    [CmdletBinding()]
    Param(
        [string]$Method,
        [string]$Resource,
        [string]$Body
    )
	
    Write-Verbose "Method: $Method"
    Write-Verbose "Resource: $Resource"
    Write-Verbose "Body: $($Body | Out-String)"
    Write-Verbose "BaseURL: $(Get-TrmmBaseURL)"

    if (($Method -eq 'put') -or ($Method -eq 'post') -or ($Method -eq 'delete')) {
        $TrmmAPIKey = Get-TrmmApiKey
        $TrmmBaseURL = Get-TrmmBaseURL
        $TrmmResult = Invoke-RestMethod -Method $method -Uri ($TrmmBaseURL + $Resource) `
            -Headers @{'x-api-key' = (New-Object PSCredential 'user', $TrmmAPIKey).GetNetworkCredential().Password; } `
            -ContentType 'application/json; charset=utf-8' -Body $Body			

    }
    else {	
        $TrmmAPIKey = Get-TrmmApiKey
        $TrmmBaseURL = Get-TrmmBaseURL
        $TrmmResult = Invoke-RestMethod -Method $method -Uri ($TrmmBaseURL + $Resource) `
            -Headers @{'x-api-key' = (New-Object PSCredential 'user', $TrmmAPIKey).GetNetworkCredential().Password; } `
            -ContentType 'application/json'
    }
	
    return $TrmmResult
}