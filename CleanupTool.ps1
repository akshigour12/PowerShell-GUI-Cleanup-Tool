Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Cleanup Tool"
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.BackColor = 'WhiteSmoke'
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(570, 520)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

$tabSystem   = New-Object System.Windows.Forms.TabPage -Property @{Text="System Cleanup"; BackColor='GhostWhite'}
$tabBrowser  = New-Object System.Windows.Forms.TabPage -Property @{Text="Browser Cleanup"; BackColor='GhostWhite'}
$tabAdvanced = New-Object System.Windows.Forms.TabPage -Property @{Text="Advanced"; BackColor='GhostWhite'}
$tabInfo     = New-Object System.Windows.Forms.TabPage -Property @{Text="Info"; BackColor='GhostWhite'}

function Add-ControlToTab($tab, [ref]$yPos, $control) {
    $control.Location = New-Object System.Drawing.Point(20, $yPos.Value)
    $tab.Controls.Add($control)
    $yPos.Value += $control.Height + 12
}

# ---------- System Cleanup ----------
$ySystem = 20
$systemOptions = @(
    @{Name="chkTemp"; Text="Clean Temp Files"},
    @{Name="chkPrefetch"; Text="Clean Prefetch"},
    @{Name="chkDownloads"; Text="Clean Downloads Folder"},
    @{Name="chkRecycle"; Text="Empty Recycle Bin"},
    @{Name="chkRecent"; Text="Clear Recent Files"}
)
foreach ($item in $systemOptions) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Name = $item.Name
    $chk.Text = $item.Text
    $chk.Size = New-Object System.Drawing.Size(300, 22)
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $chk.BackColor = 'WhiteSmoke'
    $chk.ForeColor = 'Black'
    $chk.Checked = $true
    Add-ControlToTab $tabSystem ([ref]$ySystem) $chk
}
# ---------- Browser Cleanup ----------
$yBrowser = 20
$browserOptions = @(
    @{Name="chkChrome"; Text="Clean Chrome Cache"},
    @{Name="chkEdge"; Text="Clean Edge Cache"},
    @{Name="chkFirefox"; Text="Clean Firefox Cache"}
)
foreach ($item in $browserOptions) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Name = $item.Name
    $chk.Text = $item.Text
    $chk.Size = New-Object System.Drawing.Size(300, 22)
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $chk.BackColor = 'WhiteSmoke'
    $chk.ForeColor = 'Black'
    Add-ControlToTab $tabBrowser ([ref]$yBrowser) $chk
}

# ---------- Advanced Options ----------
$yAdvanced = 20

$chkDarkMode = New-Object System.Windows.Forms.CheckBox
$chkDarkMode.Name = "chkDarkMode"
$chkDarkMode.Text = "Enable Dark Mode"
$chkDarkMode.Size = New-Object System.Drawing.Size(300, 22)
$chkDarkMode.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$chkDarkMode.BackColor = 'WhiteSmoke'
Add-ControlToTab $tabAdvanced ([ref]$yAdvanced) $chkDarkMode

$chkDarkMode.Add_CheckedChanged({
    $enabled = $chkDarkMode.Checked
    $form.BackColor = if ($enabled) { 'Black' } else { 'WhiteSmoke' }
    
    foreach ($tab in $tabControl.TabPages) {
        $tab.BackColor = if ($enabled) { 'Black' } else { 'GhostWhite' }
        foreach ($ctrl in $tab.Controls) {
            $ctrl.BackColor = if ($enabled) { 'DimGray' } else { 'WhiteSmoke' }
            $ctrl.ForeColor = if ($enabled) { 'Cyan' } else { 'Black' }

            # Special case for Run button
            if ($ctrl -eq $btnRun) {
                $btnRun.BackColor = if ($enabled) { 'DarkSlateGray' } else { 'LightGreen' }
                $btnRun.ForeColor = if ($enabled) { 'White' } else { 'Black' }
            }
        }
    }
})

$chkBackup = New-Object System.Windows.Forms.CheckBox
$chkBackup.Text = "Backup Files Before Cleanup"
$chkBackup.Name = "chkBackup"
$chkBackup.Size = New-Object System.Drawing.Size(300, 22)
$chkBackup.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$chkBackup.BackColor = 'WhiteSmoke'
Add-ControlToTab $tabAdvanced ([ref]$yAdvanced) $chkBackup

$chkDuplicates = New-Object System.Windows.Forms.CheckBox
$chkDuplicates.Text = "Scan and Remove Duplicate Files"
$chkDuplicates.Name = "chkDuplicates"
$chkDuplicates.Size = New-Object System.Drawing.Size(300, 22)
$chkDuplicates.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$chkDuplicates.BackColor = 'WhiteSmoke'
Add-ControlToTab $tabAdvanced ([ref]$yAdvanced) $chkDuplicates




# GroupBox for custom path
$grpCustom = New-Object System.Windows.Forms.GroupBox
$grpCustom.Text = "Custom Path Cleanup"
$grpCustom.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$grpCustom.Size = New-Object System.Drawing.Size(510, 100)
$grpCustom.Location = New-Object System.Drawing.Point(20, $yAdvanced)
$grpCustom.BackColor = 'WhiteSmoke'
$tabAdvanced.Controls.Add($grpCustom)
$yAdvanced += $grpCustom.Height + 12

# Textbox inside group
$txtCustomPath = New-Object System.Windows.Forms.TextBox
$txtCustomPath.Size = New-Object System.Drawing.Size(330, 22)
$txtCustomPath.Location = New-Object System.Drawing.Point(20, 25)
$txtCustomPath.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpCustom.Controls.Add($txtCustomPath)

# Browse Button inside group
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse"
$btnBrowse.Size = New-Object System.Drawing.Size(75, 24)
$btnBrowse.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$btnBrowse.BackColor = 'LightSteelBlue'
$btnBrowse.Location = New-Object System.Drawing.Point(360, 24)
$btnBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dialog.ShowDialog() -eq "OK") {
        $txtCustomPath.Text = $dialog.SelectedPath
    }
})
$grpCustom.Controls.Add($btnBrowse)

# Checkbox inside group
$chkCustomPath = New-Object System.Windows.Forms.CheckBox
$chkCustomPath.Text = "Enable Cleanup for this Path"
$chkCustomPath.Size = New-Object System.Drawing.Size(300, 22)
$chkCustomPath.Location = New-Object System.Drawing.Point(20, 55)
$chkCustomPath.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$chkCustomPath.BackColor = 'WhiteSmoke'
$grpCustom.Controls.Add($chkCustomPath)



# ---------- Info Tab ----------
$lblSysInfo = New-Object System.Windows.Forms.Label
$lblSysInfo.Size = New-Object System.Drawing.Size(530, 40)
$lblSysInfo.ForeColor = 'DarkSlateGray'
$lblSysInfo.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblSysInfo.Location = New-Object System.Drawing.Point(20, 20)
$tabInfo.Controls.Add($lblSysInfo)

$lblLastCleanup = New-Object System.Windows.Forms.Label
$lblLastCleanup.Size = New-Object System.Drawing.Size(540, 30)
$lblLastCleanup.ForeColor = 'SlateGray'
$lblLastCleanup.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblLastCleanup.Location = New-Object System.Drawing.Point(20, 60)
$tabInfo.Controls.Add($lblLastCleanup)

$statusBox = New-Object System.Windows.Forms.TextBox
$statusBox.Location = New-Object System.Drawing.Point(20, 95)
$statusBox.Size = New-Object System.Drawing.Size(520, 210)
$statusBox.Multiline = $true
$statusBox.ScrollBars = "Vertical"
$statusBox.ReadOnly = $true
$statusBox.BackColor = 'Ivory'
$statusBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$tabInfo.Controls.Add($statusBox)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 310)
$progressBar.Size = New-Object System.Drawing.Size(520, 22)
$tabInfo.Controls.Add($progressBar)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run Cleanup"
$btnRun.Size = New-Object System.Drawing.Size(140, 35)
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRun.BackColor = 'LightGreen'
$btnRun.Location = New-Object System.Drawing.Point(215, 350)
$tabInfo.Controls.Add($btnRun)

# ---------- Utility Functions ----------
function Get-SysInfo {
    $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
    $ram = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024, 2)
    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    return "CPU: $cpu`% | Free RAM: $ram MB | Uptime: $($uptime.ToString().Split('.')[0])"
}
function Save-LastCleanup {
    "$((Get-Date).ToString())" | Out-File "$env:APPDATA\cleanup_last_run.txt" -Force
}
function Get-LastCleanup {
    $f = "$env:APPDATA\cleanup_last_run.txt"
    if (Test-Path $f) { return Get-Content $f } else { return "Never run" }
}

function Find-Duplicates($paths) {
    $files = $paths | ForEach-Object {
        if (Test-Path $_) { Get-ChildItem $_ -Recurse -File -ErrorAction SilentlyContinue }
    }
    $dupes = $files | Group-Object { "$($_.Name)-$($_.Length)" } | Where-Object { $_.Count -gt 1 }
    $yesToAll = $false; $noToAll = $false

    foreach ($set in $dupes) {
        foreach ($file in $set.Group[1..($set.Group.Count - 1)]) {
            if ($noToAll) {
                $statusBox.AppendText("Skipped: $($file.FullName)`r`n")
                continue
            }

            if ($yesToAll) {
                Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
                $statusBox.AppendText("Deleted: $($file.FullName)`r`n")
                continue
            }

            $prompt = [System.Windows.Forms.MessageBox]::Show(
                "Duplicate file found:`n$($file.FullName)`nDo you want to delete it?",
                "Delete Duplicate?",
                [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )

            if ($prompt -eq "Yes") {
                Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
                $statusBox.AppendText("Deleted: $($file.FullName)`r`n")
            }
            elseif ($prompt -eq "No") {
                $statusBox.AppendText("Skipped: $($file.FullName)`r`n")
            }
            elseif ($prompt -eq "Cancel") {
                $followup = [System.Windows.Forms.MessageBox]::Show(
                    "Apply to all remaining duplicates?",
                    "Apply to All?",
                    [System.Windows.Forms.MessageBoxButtons]::YesNo,
                    [System.Windows.Forms.MessageBoxIcon]::Question
                )
                if ($followup -eq "Yes") { $yesToAll = $true }
                else { $noToAll = $true }
            }
        }
    }

    if ($dupes.Count -eq 0) {
        $statusBox.AppendText("No duplicate files found.`r`n")
    }
}

# ---------- Run Button Logic ----------
$btnRun.Add_Click({
    $statusBox.Clear(); $progressBar.Value = 0
    $tasks = @()

    if ($tabSystem.Controls["chkTemp"].Checked)     { $tasks += @{Label="Temp"; Action={ Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue }} }
    if ($tabSystem.Controls["chkPrefetch"].Checked) { $tasks += @{Label="Prefetch"; Action={ Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue }} }
    if ($tabSystem.Controls["chkDownloads"].Checked){ $tasks += @{Label="Downloads"; Action={ Remove-Item "$env:USERPROFILE\Downloads\*" -Recurse -Force -ErrorAction SilentlyContinue }} }
    if ($tabSystem.Controls["chkRecycle"].Checked)  { $tasks += @{Label="Recycle Bin"; Action={ Clear-RecycleBin -Force -ErrorAction SilentlyContinue }} }
    if ($tabSystem.Controls["chkRecent"].Checked)   { $tasks += @{Label="Recent"; Action={ Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue }} }

    if ($tabBrowser.Controls["chkChrome"].Checked) {
        $tasks += @{Label="Chrome"; Action={
            $p = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
            if (Test-Path $p) { Remove-Item "$p\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }}
    }
    if ($tabBrowser.Controls["chkEdge"].Checked) {
        $tasks += @{Label="Edge"; Action={
            $p = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
            if (Test-Path $p) { Remove-Item "$p\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }}
    }
    if ($tabBrowser.Controls["chkFirefox"].Checked) {
        $tasks += @{Label="Firefox"; Action={
            Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | ForEach-Object {
                $p = Join-Path $_.FullName "cache2"
                if (Test-Path $p) { Remove-Item "$p\*" -Recurse -Force -ErrorAction SilentlyContinue }
            }
        }}
    }

    if ($chkCustomPath.Checked -and $txtCustomPath.Text -ne "") {
        $tasks += @{Label="Custom Path"; Action={
            if (Test-Path $txtCustomPath.Text) {
                Remove-Item "$($txtCustomPath.Text)\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }}
    }

    if ($tabAdvanced.Controls["chkDuplicates"].Checked) {
        $tasks += @{Label="Duplicate Files"; Action={
            $paths = @("$env:USERPROFILE\Downloads", "$env:USERPROFILE\Documents")
            if ($chkCustomPath.Checked -and $txtCustomPath.Text -ne "") {
                $paths += $txtCustomPath.Text
            }
            Find-Duplicates $paths
        }}
    }

    $stepCount = $tasks.Count
    for ($i = 0; $i -lt $stepCount; $i++) {
        $progressBar.Value = [math]::Round((($i+1)/$stepCount)*100)
        $statusBox.AppendText("$($tasks[$i].Label)...`r`n")
        & $tasks[$i].Action
        Start-Sleep -Milliseconds 300
    }

    Save-LastCleanup
    $statusBox.AppendText("Cleanup Completed.`r`n")
    [System.Windows.Forms.MessageBox]::Show("Cleanup complete!", "Done", "OK", "Information")
})

$tabControl.TabPages.AddRange(@($tabSystem, $tabBrowser, $tabAdvanced, $tabInfo))
$form.Controls.Add($tabControl)
$form.Add_Shown({
    $lblSysInfo.Text = Get-SysInfo
    $lblLastCleanup.Text = "Last Cleanup: " + (Get-LastCleanup)
})
[void]$form.ShowDialog()
