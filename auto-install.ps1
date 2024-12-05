# Install TrueType font files
# $font1Path = "D:\auto-install\1Archivo1.ttf"
# $font2Path = "D:\auto-install\1Archivo2.ttf"
# $fontsFolder = "$($env:SystemRoot)\Fonts"

Write-Host "Installing fonts..."
# Copy-Item $font1Path $fontsFolder -Force
# Copy-Item $font2Path $fontsFolder -Force

$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Recurse -include *.ttf | ForEach-Object { $fonts.CopyHere($_.fullname) }

Write-Host "Fonts installed."


# Install executable files
Write-Host "Installing executables..."

Start-Process ".\2Ninite.exe" -Verb RunAs -Wait

Start-Process "D:\auto-install\RMM_AGENT.EXE" -Verb RunAs -Wait

Start-Process -FilePath "msiexec.exe" -ArgumentList "/quiet /i .\LastPassInstaller.msi ADDLOCAL=ChromeExtension,GenericShortcuts,DesktopShortcut,EdgeExtension,LastPassUwpApp,Updater" -Verb RunAs -Wait

Start-Process ".\4Teams.exe" -Verb RunAs -Wait


Start-Process ".\3Office.exe" -Verb RunAs -Wait


Write-Host "Installation complete."

Start-Sleep -s 60

# Call the rename-pc.ps1 script
$renameScriptPath = ".\rename-pc.ps1"
if (Test-Path $renameScriptPath) {
    Write-Host "Renaming computer..."
    & $renameScriptPath
} else {
    Write-Warning "The rename-pc.ps1 script could not be found at $renameScriptPath."
}

# Call the disable-sleep.ps1 script
$disableSleepScriptPath = ".\disable-sleep.ps1"
if (Test-Path $disableSleepScriptPath) {
    Write-Host "Disabling sleep mode..."
    & $disableSleepScriptPath
} else {
    Write-Warning "The disable-sleep.ps1 script could not be found at $disableSleepScriptPath."
}