# Environment Setup and Build Instructions

This guide assumes you have already cloned the repo and are inside the project root directory.

---

## 1. Install required tools

### **Windows Setup**

Run all commands from an elevated Windows PowerShell or PowerShell 7 session. Do not use WSL.

```powershell
# Install Chocolatey, a Windows package manager:
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Verify Choco installation:
choco --version

# Install required tools:
choco install vagrant virtualbox packer -y

# Verify versions:
vagrant --version
VBoxManage --version
packer version

# Confirm binaries resolve from PATH:
where.exe vagrant
where.exe VBoxManage
where.exe packer
```

If commands are not recognized, close and reopen the shell.

---

### **macOS and Linux Setup**

Install required tools using your system package manager.

Examples:

```bash
# macOS:
brew install vagrant virtualbox packer

# Linux (Debian or Ubuntu):
sudo apt update
sudo apt install vagrant virtualbox packer

# Verify versions:
vagrant --version
VBoxManage --version
packer version
```

---

## 2. Building the Base Image

From the repo root:

```bash
cd packer
packer init .
packer validate .
packer build rocky9.pkr.hcl
```

### **Expected Behavior:**

- Total build time is typically 25-35 min depending on hardware and network speed. Users can confirm system processes are running by checking running tasks.
- The inital build process is intended to be fully automated and should not require input from the user.
- Since there is no GUI, headless mode has been enabled during setup to provide visibility into the process until logging is implemented.
- Once SSH becomes available, Packer completes provisioning.
- After completion, a .box file will be created in the `packer/` directory.

#### **Confirm artifact creation:**

Windows:

```powershell
Get-ChildItem *.box
```

macOS/Linux:

```bash
ls -la *.box
```

---

## 3. Use the Box with Vagrant

Return to repo root if needed:

```bash
cd ..
```

**Windows:**

```powershell
vagrant box add --name rocky-base-v.1 --provider virtualbox .\packer\rocky-base-v.1.box
cd vagrant
vagrant up --provider virtualbox
vagrant ssh
```

**macOS/Linux:**

```bash
vagrant box add --name rocky-base-v.1 --provider virtualbox ./packer/rocky-base-v.1.box
cd vagrant
vagrant up --provider virtualbox
vagrant ssh
```

If rebuilding and replacing the local box:

```bash
vagrant box add --force --name rocky-base-v.1 ./packer/rocky-base-v.1.box
```

Viewing Available Vagrant Commands:

```bash
# to see all available Vagrant commands
vagrant --help 

# to see usage and options for a specific command
vagrant <command> --help 

# example usage
vagrant up --help 
```
