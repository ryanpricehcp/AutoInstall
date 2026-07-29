Write-Host "Installing fonts..."
# Copy-Item $font1Path $fontsFolder -Force
# Copy-Item $font2Path $fontsFolder -Force


# Call the rename-pc.ps1 script
$renameScriptPath = ".\auto_install\rename-pc.ps1"
if (Test-Path $renameScriptPath) {
    Write-Host "Renaming computer..."
    & $renameScriptPath
} else {
    Write-Warning "The rename-pc.ps1 script could not be found at $renameScriptPath."
}


# Call the disable-sleep.ps1 script
$disableSleepScriptPath = ".\auto_install\disable-sleep.ps1"
if (Test-Path $disableSleepScriptPath) {
    Write-Host "Disabling sleep mode..."
    & $disableSleepScriptPath
    write-host "Sleep mode disabled." -ForegroundColor Green
} else {
    Write-Warning "The disable-sleep.ps1 script could not be found at $disableSleepScriptPath."
}


$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Recurse -include *.ttf | ForEach-Object { $fonts.CopyHere($_.fullname) }

Write-Host "Fonts installed." -ForegroundColor Green


# Install executable files
Write-Host "Installing executables..."

Start-Process ".\auto_install\3Office.exe" -Verb RunAs

$seconds = 600
for ($i = $seconds; $i -ge 0; $i--) {
    Write-Progress -Activity "Waiting..." -Status "$i seconds remaining" -PercentComplete ((($seconds - $i) / $seconds) * 100)
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "Waiting..." -Completed

Start-Process ".\auto_install\RMM_AGENT.EXE" -Verb RunAs -Wait

# Allow Rapid7 and Cisco Umbrella time to finish installing background dependencies
$depSeconds = 1800
Write-Host "Waiting for security agent dependencies (Rapid7, Cisco Umbrella) to finish..." -ForegroundColor Cyan
for ($i = $depSeconds; $i -ge 0; $i--) {
    Write-Progress -Activity "Waiting for security agents..." -Status "$i seconds remaining" -PercentComplete ((($depSeconds - $i) / $depSeconds) * 100)
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "Waiting for security agents..." -Completed

Start-Process -FilePath "msiexec.exe" -ArgumentList "/quiet /i .\auto_install\LastPassInstaller.msi ADDLOCAL=ChromeExtension,GenericShortcuts,DesktopShortcut,EdgeExtension,LastPassUwpApp,Updater" -Verb RunAs -Wait

Start-Process ".\auto_install\4Teams.exe" -Verb RunAs -Wait
# winget install Microsoft.Teams --silent

Start-Process ".\auto_install\2Ninite.exe" -Verb RunAs -Wait

Write-Host "Installation complete." -ForegroundColor Green

Start-Sleep -s 30




# Call the set-mtntime.ps1 script
$setTimezoneScriptPath = ".\auto_install\set-mtntime.ps1"
if (Test-Path $setTimezoneScriptPath) {
    Write-Host "Setting timezone to Mountain Standard Time..."
    & $setTimezoneScriptPath
} else {
    Write-Warning "The set-mtntime.ps1 script could not be found at $setTimezoneScriptPath."
}

# $update = Read-Host "Would you like to install Windows updates? This will automatically reboot the computer. (Y/N)"


# Install Windows updates
# if ($update -eq "Y") {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module -Name PSWindowsUpdate -Repository PSGallery -Scope AllUsers -Confirm:$false -ErrorAction Stop
    # Get-WindowsUpdate
    # Read-Host "Press Enter to continue..."


    
    Write-Host "Installing Windows updates..."
    Install-WindowsUpdate -AcceptAll -AutoReboot
# } else {
#     Write-Host "Windows updates will not be installed."
# }