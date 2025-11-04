powercfg.exe -x standby-timeout-ac 0
powercfg.exe -x monitor-timeout-ac 30
Set-Location -LiteralPath C:\Users\hcp\Desktop\
Invoke-WebRequest 'https://github.com/ryanpricehcp/AutoInstall/archive/refs/heads/main.zip' -OutFile .\auto_install.zip
Expand-Archive .\auto_install.zip .\
Rename-Item .\AutoInstall-main .\auto_install
Remove-Item .\auto_install.zip
& .\auto_install\auto-install.ps1