## Release Notes

### Version 0.2.3
Added `Get-TrmmAgents`

### Version 0.2.2
Added `Get-WindowsUpdatesFromTRMM`

### Version 0.2.1
Fix a bug with missing `Get-TrmmBaseURL` cmdlet

### Version 0.2.0
Reworked the structure of the module to improve flexibility.  Cmdlets will now call the `Invoke-TrmmRequest` function instead of `Invoke-WebRequest`.  The API keys are now stored as a secure string and will only need to be entered at the start of the Powershell session. 


### Version 0.1.0
Created Get-SotwareFromTRMM.ps1 as proof of concept


## Description
Unofficial powershell module to allow access to the Tactical RMM API.  I am not associated with Tactical RMM other than as a customer.


## Installation
`Install-Module -Name PoshTRMM`

## Cmdlets
```
Get-SoftwareFromTRMM
Get-TrmmApiKey
New-TrmmApiKey
Remove-TrmmApiKey
New-TrmmBaseURL
Invoke-TrmmRequest
Get-TrmmBaseUrl
Get-WindowsUpdatesFromTRMM
Get-TrmmAgents
```

## Usage
After installing the module, get an API key from Settings > Global Settings > API Keys

```
    New-TrmmApiKey "Your API Key"
    New-TrmmBaseUrl "https://api.example.com"
    Get-SoftwareFromTRMM -Clients 'ACME Inc','Contoso','Some Other Client Name'
```

## Examples

This will export the list of software for Client 'ACME Inc' to a CSV file
```
Get-SoftwareFromTRMM -Clients 'ACME Inc' | ConvertTo-Csv | Out-File C:\Temp\Acme_Software_List.csv
```

This will show all machines with "Citrix Workspace" installed
```
Get-SoftwareFromTRMM | Where-Object {$_.Name -match "Citrix Workspace \d+"}
```

This will show all machines with Chrome versions older than 107
```
Get-SoftwareFromTRMM | Where-Object {$_.Name -like "Google Chrome" -and $_.Version -lt [system.version]"107.0.0"}
```
