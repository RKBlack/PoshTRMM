function New-TrmmAPIKey {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true)]
        [String]
        $ApiKey
    )
		
    if ($ApiKey) {
        $SecApiKey = ConvertTo-SecureString $ApiKey -AsPlainText -Force
    }
    else {
        Write-Host 'Please enter your API key, you can obtain it from Settings > Global Settings > API Keys'
        $SecApiKey = Read-Host -AsSecureString
    }
    Set-Variable -Name 'Int_TrmmAPIKey' -Value $SecApiKey -Visibility Private -Scope script -Force
}