function New-TrmmBaseURL {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true)]
        [String]
        $BaseURL
    )
		
    if (!$BaseURL) {
        Write-Host 'Please enter your Tactical Base URL with no trailing /, for example https://api.example.com :'
        $BaseURL = Read-Host
    }
    Set-Variable -Name 'Int_TrmmBaseURL' -Value $BaseURL -Visibility Private -Scope script -Force
}