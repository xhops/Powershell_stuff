#quick one-liner script to identify wmiobjects

Get-WmiObject win32_service | select Name, DisplayName | Format-List
