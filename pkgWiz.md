# Package Managers for Windows

OneGet (Windows Package Management) is a convenient tool for managing software packages from various providers on Windows. Here's how to install OneGet and list the available package providers.

## Install OneGet

1. Open PowerShell with administrator privileges.
2. Run the following command to install the PackageManagement module (OneGet):

   ```powershell
   Install-Module -Name PackageManagement -Force -AllowClobber
   ```

## Install Package Providers (Optional)

If you find that certain package providers are missing, you can install them using the following commands:

- **Chocolatey:**

  ```powershell
  Install-PackageProvider -Name Chocolatey -Force
  ```

- **winget:**

  ```powershell
  Install-PackageProvider -Name winget -Force
  ```

- **NuGet:**

  ```powershell
  Install-PackageProvider -Name NuGet -Force
  ```

- **Python:**

  ```powershell
  Install-PackageProvider -Name Python -Force
  ```

- **PSModule:**

  ```powershell
  Install-PackageProvider -Name PSModule -Force
  ```

- **PowerShellGet:**
  ```powershell
  Install-PackageProvider -Name PowerShellGet -Force
  ```

## Verify Installed Package Providers

Run the `Get-PackageProvider` command again to verify that the desired package providers are now installed and available for use.

```powershell
Get-PackageProvider
```

That's it! You've successfully installed OneGet and explored the available package providers. You can now use OneGet to manage software packages from different sources right from your PowerShell prompt.
