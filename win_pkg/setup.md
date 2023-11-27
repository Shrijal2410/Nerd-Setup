# Windows Package Manager Setup Guide 🚀

Introducing the **Windows Package Manager**, your go-to solution for seamless software management on Windows.

## Winget

Winget is the native package manager for Windows, ensuring hassle-free software installations and updates.

### ✨ Install

- Launch PowerShell as an admin (Hold Win + X, then press A).

```powershell
# Get latest download URL
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

# Download
Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing
# Install 🚀
Add-AppxPackage -Path "Setup.msix"
# Delete file
Remove-Item "Setup.msix"
```

✅ **Verify**

```powershell
winget -v
```

- [Stack Overflow Installation Guide](https://stackoverflow.com/questions/74166150/install-winget-by-the-command-line-powershell)
- [Upgrade Winget](https://github.com/microsoft/winget-cli/issues/505)
- [Uninstallation Discussions](https://github.com/microsoft/winget-cli/discussions/844).

**Official Resources**

- [Official Documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [GitHub Repository](https://github.com/microsoft/winget-cli)

## Chocolatey

Chocolatey is a powerful package manager for Windows, offering extensive libraries and easy updates.

### ✨ Install

- Launch PowerShell as an admin (Hold Win + X, then press A).

```powershell
# Run in PowerShell as admin
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

✅ **Verify**

```powershell
choco
```

### 🚀 Upgrade

```powershell
choco upgrade chocolatey
```

### ❌ Uninstall

Delete its installation folder (usually in C:\ProgramData\chocolatey). Backup sub-folders like lib and bin before deletion. Adjust system environment variables by removing ChocolateyInstall and ChocolateyToolsLocation, and update PATH to exclude Chocolatey's bin directory. Utilize the provided PowerShell script for automated removal. Remember to back up your data before making changes.

```powershell
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
```

**Official Resources**

- [Official Documentation](https://docs.chocolatey.org/en-us/choco/setup)
- [GitHub Repository](https://github.com/chocolatey/choco)

Happy package managing on Windows! 😊
