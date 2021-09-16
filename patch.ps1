Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
$running = $true
$Host.UI.RawUI.BackgroundColor = "DarkBlue"
function displayProcess 
{
    $saveFolder = New-Object System.Windows.Forms.saveFiledialog -Property @{
        InitialDirectory = [Environment]::GetFolderPath('Desktop')
        Filter = "Log Files|*.Log|Text File|*.txt| All Files| *.*"
        Title = 'Save As'
        ShowHelp = $true 
        
     }
    
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text = 'Processor Monitor'
    $main_form.Width = 850
    $main_form.Height = 600
    $main_form.AutoSize = $true
    $main_form.StartPosition = 'CenterScreen'
    $main_form.BackColor = '#9e9c96'


    $btnScheduled = New-Object System.Windows.Forms.Button
    $btnScheduled.Enabled = $true
    $btnScheduled.Location = New-Object System.Drawing.Size(250,40)
    $btnScheduled.Size = New-Object System.Drawing.Size(400, 25)
    $btnScheduled.Text = 'Show Scheduled Tasks'
    $btnScheduled.Add_Click(
    {
        $lstTasks.Items.Clear()
        $lstTasks.Items.Add("Scheduled Tasks:")
        $lstTasks.Items.Add("")
        foreach($task in Get-ScheduledTask | Select-Object -Property TaskName | Sort-Object -Property TaskName)
        {
            $lstTasks.Items.Add($task.TaskName)
        }
        $lstTasks.Enabled = $true
        $btnDelete.Enabled = $true
        $btnRemove.Enabled = $true
    })

    $lstProcess = New-Object System.Windows.Forms.ListBox
    $lstProcess.Location = New-Object System.Drawing.Point(30,70)
    $lstProcess.Width = 400
    $lstProcess.Height = 400
    $lstProcess.BackColor = "#000000"
    $lstProcess.ForeColor = "#ffffff"
    $lstProcess.Items.Add("Top 20 Running Processes:")
    $lstProcess.Items.Add("")
    foreach($process in Get-Process| Sort-Object -Property CPU -Descending | Select-Object -Property Name -First 20)
    {
        $lstProcess.Items.Add($process.Name)
    }

    $lstProcess.Add_Click(
    {
 
        if(($lstProcess.SelectedItem.ToString() -ne "") -and ($lstProcess.SelectedItem.ToString() -ne "Top 20 Running Processes:"))
        {
            Write-Host $lstProcess.SelectedItem.ToString() 
            $btnStop.Enabled = $true
        }
        else
        {
            $btnStop.Enabled = $false
        }
    })


    $lstTasks = New-Object System.Windows.Forms.ListBox
    $lstTasks.Location = New-Object System.Drawing.Point(450,70)
    $lstTasks.Width = 400
    $lstTasks.Height = 400
    $lstTasks.Enabled = $false
     

    $lstTasks.Add_Click(
    {
        if($lstTasks.SelectedItem.ToString() -ne "Scheduled Tasks:" -and $lstProcess.SelectedItem.ToString() -ne "")
        {
            $btnDelete.Enabled = $true
            $btnOpen.Enabled = $true
        }
    })


    $btnStop = New-Object System.Windows.Forms.Button
    $btnStop.Enabled = $false
    $btnStop.Location = New-Object System.Drawing.Size(40,500)
    $btnStop.Size = New-Object System.Drawing.Size(120,25)
    $btnStop.Text = 'End Process'
    $btnStop.Add_Click(
    {
        $procName = $lstProcess.SelectedItem.ToString()
        $msgBoxInput =  [System.Windows.MessageBox]::Show('Are you sure that you want to remove the process ' + $procName + "?",'End Process','YesNoCancel','Question')
        switch ($msgBoxInput)
        {
            'yes'
        {
            
            Stop-Process -Name $procName -Force -Confirm:$false 
            foreach($process in Get-Process| Select-Object -Property Name -First 10 | Sort-Object -Property CPU -Descending)
            {
                $lstProcess.Items.Add($process.TaskName)
            }
        }
        'no'
        {

        }
        'cancel'
        {

        }
       }
    })

    $btnRefresh = New-Object System.Windows.Forms.Button
    $btnRefresh.Enabled = $true
    $btnRefresh.Location = New-Object System.Drawing.Size(170,500)
    $btnRefresh.Size = New-Object System.Drawing.Size(120,25)
    $btnRefresh.Text = 'Refresh'
    $btnRefresh.Add_click({
        $lstProcess.Items.Clear()
        $lstProcess.Items.Add("Top 20 Running Processes:")
        $lstProcess.Items.Add("")
        foreach($process in Get-Process| Sort-Object -Property CPU -Descending | Select-Object -Property Name -First 20)
        {
            $lstProcess.Items.Add($process.Name)
        }
    })


    $btnSave = New-Object System.Windows.Forms.Button
    $btnSave.Location = New-Object System.Drawing.Size(300,500)
    $btnSave.Size = New-Object System.Drawing.Size(120,25)
    $btnSave.Text = 'Save'

    $btnSave.Add_Click(
    {
        $saveFolder.ShowDialog()
        

  

        $CPUPercent = @{
            Name = ‘CPUPercent’
            Expression = 
            {
                $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
                [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
            }
        }

        do{

            Get-Process |
            Select-Object -Property Name, CPU, $CPUPercent, Description |
            Sort-Object -Property CPUPercent -Descending |
            where-object {$_.CPUPercent -gt 5} |
            out-file -filepath $saveFolder.FileName -encoding ASCII -width 70 -Append

            $i++
            Start-Sleep -s 10

        } while ($i -lt 6)

        [System.Media.SystemSounds]::Beep.Play()

        $msgBoxInput =  [System.Windows.MessageBox]::Show(“Now wasn’t that fun.. Let’s See Whats in the file. :)”, "Processes Logged",'OK','Information')

        Invoke-Item $saveFolder.FileName
    })

    $btnDelete = New-Object System.Windows.Forms.Button
    $btnDelete.Enabled = $false
    $btnDelete.Location = New-Object System.Drawing.Size(450,500)
    $btnDelete.Size = New-Object System.Drawing.Size(120,25)
    $btnDelete.Text = 'Remove Task'
    $btnDelete.Add_Click(
    {
       $taskName = $lstTasks.SelectedItem.toString()
       $msgBoxInput =  [System.Windows.MessageBox]::Show('Are you sure that you want to remove the task' + $taskName + "? `r`n (You cannot recover the task once removed)",'Remove Task','YesNoCancel','Warning')
       switch ($msgBoxInput)
       {
        'yes'
        {
            
            Stop-ScheduledTask -TaskName $taskName
            Disable-ScheduledTask -TaskName $taskName
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            $lstTasks.Items.Clear()
            $lstTasks.Items.Add("Scheduled Tasks:")
            $lstTasks.Items.Add("")
            foreach($task in Get-ScheduledTask | Sort-Object -Property TaskName)
            {
                $lstTasks.Items.Add($task.TaskName)
            }
        }
        'no'
        {

        }
        'cancel'
        {

        }
       }
    })

    $btnRemove = New-Object System.Windows.Forms.Button
    $btnRemove.Enabled = $false
    $btnRemove.Location = New-Object System.Drawing.Size(680,500)
    $btnRemove.Size = New-Object System.Drawing.Size(150,25)
    $btnRemove.Text = 'Task Was Not Removed?'
    $btnRemove.Add_Click(
    {
        $msgBoxInput =  [System.Windows.MessageBox]::Show("Delete Task Manually and try again", "Task Was not removed",'OK','Warning')
        $btnDelete.Enabled = $false
        Invoke-Item C:\Windows\System32\Tasks
    
    })

    $main_form.Controls.Add($lstProcess)
    $main_form.Controls.Add($lstTasks)
    $main_form.Controls.Add($btnDelete)
    $main_form.Controls.Add($btnStop)
    $main_form.Controls.Add($btnRemove)
    $main_form.Controls.Add($btnScheduled)
    $main_form.Controls.Add($btnSave)
    $main_form.Controls.Add($btnRefresh)
    $main_form.ShowDialog()
}

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
$cpu_threshold = 85
$sleep_interval = 5
$hit = 0
$iloop = 0
While($isRunning -ne $false) 
{
    $cpu = (gwmi -class Win32_Processor).LoadPercentage
    $CPUPercent = @{
        Name = ‘CPUPercent’
        Expression = 
        {
            $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
            [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
        }
    }
	clear-host
	write-host “CPU utilization is currently at $cpu%”
    
     
    If($cpu -ge $cpu_threshold) 
    {
        $hit = $hit+1
    }
	if($iloop -ge 5)
	{
		$hit = 0
        $iloop = 0
	}
    start-sleep $sleep_interval
    if($hit -eq 3) 
    {
        $msgBoxInput =  [System.Windows.MessageBox]::Show("CPU Utilization is more than 85`% `r`n Would you like to view the top processes”,'CPU is over threshold level','YesNoCancel','Warning')
        switch  ($msgBoxInput) 
        {

            'Yes' 
            {
                displayProcess
                
            }
            'No'
            {
                
            }
            'Cancel'
            {
               
            }
        }
        
        #Send-MailMessage –From CryptoMonito@mail.com –To 201477488@student.uj.ac.za –Subject “CPU Utilization is more than 85`%” –Body “CPU Utilization is more than $cpu_threshold`%” –SmtpServer smtpserver.domain.com

        $hit = 0
        $loop = 0
    } 
    else
    {
		If($cpu -ge $cpu_threshold) 
		{
			$Host.UI.RawUI.BackgroundColor = "DarkRed"
			Write-Host "Intense Running Processes:"
			Get-Process | Sort-Object -Property CPUPercent -Descending | Select-Object -Property Name, CPU, $CPUPercent, Description -First 20

		}else
		{	
			write-host “CPU utilization is below threshold level”
			$Host.UI.RawUI.BackgroundColor = "DarkBlue"
		}
    }
	$iloop = $iloop + 1
}



    