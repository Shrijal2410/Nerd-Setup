# Set VerbosePreference to 'Continue' to enable verbose output
$VerbosePreference = 'Continue'

# Check if Chocolatey is installed by verifying the ChocolateyInstall environment variable
if (-not $env:ChocolateyInstall) {
    # Chocolatey is not detected as installed, display a warning and exit
    $message = @(
        "The ChocolateyInstall environment variable was not found.",
        "Chocolatey is not detected as installed. Nothing to do."
    ) -join "`n"
    Write-Warning $message
    return
}

# Check if Chocolatey installation path exists
if (-not (Test-Path $env:ChocolateyInstall)) {
    # Chocolatey installation path not found, display a warning and exit
    $message = @(
        "No Chocolatey installation detected at '$env:ChocolateyInstall'.",
        "Nothing to do."
    ) -join "`n"
    Write-Warning $message
    return
}

# Backup the current user and machine PATH environment variables
# Note: Using .NET registry calls to preserve variable references in PATH values
$userKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
$userPath = $userKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

$machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\ControlSet001\Control\Session Manager\Environment\', $true)
$machinePath = $machineKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

$backupPATHs = @(
    "User PATH: $userPath",
    "Machine PATH: $machinePath"
)
$backupFile = "C:\PATH_backups_ChocolateyUninstall.txt"
$backupPATHs | Set-Content -Path $backupFile -Encoding UTF8 -Force

# Warning message for potential issues after reboot
$warningMessage = @"
    This could cause issues after reboot where nothing is found if something goes wrong.
    In that case, look at the backup file for the original PATH values in '$backupFile'.
"@

# Remove Chocolatey installation path from user and machine PATH variables
if ($userPath -like "*$env:ChocolateyInstall*") {
    Write-Verbose "Chocolatey Install location found in User Path. Removing..."
    Write-Warning $warningMessage

    $newUserPATH = @(
        $userPath -split [System.IO.Path]::PathSeparator |
        Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
    ) -join [System.IO.Path]::PathSeparator

    # Update user PATH variable
    $userKey.SetValue('PATH', $newUserPATH, 'ExpandString')
}

if ($machinePath -like "*$env:ChocolateyInstall*") {
    Write-Verbose "Chocolatey Install location found in Machine Path. Removing..."
    Write-Warning $warningMessage

    $newMachinePATH = @(
        $machinePath -split [System.IO.Path]::PathSeparator |
        Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
    ) -join [System.IO.Path]::PathSeparator

    # Update machine PATH variable
    $machineKey.SetValue('PATH', $newMachinePATH, 'ExpandString')
}

# Stop the chocolatey-agent service if running
$agentService = Get-Service -Name chocolatey-agent -ErrorAction SilentlyContinue
if ($agentService -and $agentService.Status -eq 'Running') {
    $agentService.Stop()
}
# TODO: Add code to stop other services running from subfolders of ChocolateyInstall

# Remove Chocolatey installation directory and related environment variables
Remove-Item -Path $env:ChocolateyInstall -Recurse -Force
'ChocolateyInstall', 'ChocolateyLastPathUpdate' | ForEach-Object {
    foreach ($scope in 'User', 'Machine') {
        # Clear Chocolatey related environment variables
        [Environment]::SetEnvironmentVariable($_, [string]::Empty, $scope)
    }
}

# Remove ChocolateyToolsLocation and related environment variables
if ($env:ChocolateyToolsLocation -and (Test-Path $env:ChocolateyToolsLocation)) {
    Remove-Item -Path $env:ChocolateyToolsLocation -Recurse -Force
}

foreach ($scope in 'User', 'Machine') {
    # Clear ChocolateyToolsLocation environment variables
    [Environment]::SetEnvironmentVariable('ChocolateyToolsLocation', [string]::Empty, $scope)
}

# Close registry keys
$machineKey.Close()
$userKey.Close()