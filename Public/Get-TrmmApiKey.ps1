function Get-TrmmApiKey {
	[CmdletBinding()]
	Param()
	if ($null -eq $Int_TrmmAPIKey) {
		Write-Error "No API key has been set. Please use New-TrmmAPIKey to set it."
	} else {
		$Int_TrmmAPIKey
	}
}