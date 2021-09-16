@echo off
set currentDir=%~dp0
Powershell.exe -NoP -NonI -W Hidden -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -WindowStyle Minimized -ExecutionPolicy Bypass -File ""%~dp0patch.ps1""'-Verb Runas }"