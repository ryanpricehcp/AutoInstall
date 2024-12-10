# Set the timezone to Mountain Standard Time (MST)
Set-TimeZone -Id "Mountain Standard Time"

# Verify the change
Write-Host "Verification that the timezone was set to Mountain Standard Time" -ForegroundColor Green -NoNewline
Get-TimeZone