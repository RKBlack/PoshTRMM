function Remove-TrmmAPIKey {
	[CmdletBinding()]
	Param()
	Set-Variable -Name "Int_TrmmAPIKey" -Value $null -Visibility Private -Scope script -Force
}