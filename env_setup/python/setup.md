# Python Development Environment Setup Guide 🐍

## Miniconda

Miniconda is a minimal Python distribution that allows you to create a customized Python environment for your projects. It's perfect for those who prefer a lightweight package manager. _Here's how to get started:_

### ✨ Install

Download and install Miniconda (for the current user only)

```bash
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -o miniconda.exe
start /wait "" miniconda.exe /InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /S
# add path: /D=%UserProfile%\Miniconda3
del miniconda.exe
```

✅ **Verify**

```bash
conda --version
```

### 🚀 Upgrade

```bash
conda update conda
```

### ❌ Uninstall

```bash
conda install anaconda-clean
anaconda-clean --yes
```

Your Python environment is set! Happy coding! 😊
