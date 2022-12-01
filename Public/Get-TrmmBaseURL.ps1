function Get-TrmmBaseURL {
	[CmdletBinding()]
	Param()
	if ($null -eq $Int_TrmmBaseURL) {
		Write-Error "No Base URL has been set. Please use New-TrmmBaseURL to set it."
	} else {
		$Int_TrmmBaseURL
	}
}