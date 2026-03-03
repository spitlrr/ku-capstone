# DevSecOps: Automating Security Baselines <br>with Infrastructure and Compliance as Code</br>


## Project overview
Capstone is a senior level course designed to allow a student to review, analyze, integrate, and apply technical knowledge in a meaningful and practical manner. The capstone course will be used to integrate concepts from IT curriculum coursework as well as professional and managerial coursework into a project that allows students to put skills into action.

This project focuses on using DevSecOps practices to automate the application of security baselines during system provisioning and deployment. By using Infrastructure as Code (IaC) and Compliance as Code (CaC), security controls are built directly into the deployment process rather than manually after systems are deployed. This approach promotes consistency, repeatability, and an improved security posture.

## Purpose
The purpose of this project is to demonstrate how automated deployment packages can apply standardized security baselines throughout a defined software development lifecycle in support of secure design practices. The project emphasizes integrating security into DevOps processes rather than a separate or reactive step.

This includes:
   - Configuration Management 
   - System provisioning
   - Deployment
   - Monitoring
   - Auditing
   - Reporting

## Prerequisites

- Git
- VirtualBox Cli (VBoxManage) >=7.2.x
- Vagrant >=2.4.x
- Packer >=1.7.x
- PowerShell 7 recommended. Windows PowerShell 5.1 supported.

#### *For detailed set up instructions, please see [SETUP.md](SETUP.md).*

## Installation

**Windows**:

Run all commands from an elevated Windows PowerShell or PowerShell 7 session. It is recommended not to use WSL. If commands are not recognized, try closing and reopening the shell.

**Intel Macs/Linux**:

Install VirtualBox, Vagrant, and Packer using your system package manager and ensure virtualization is enabled.

## Getting started
Clone the shared repo to your local machine:
 ```bash
git clone https://github.com/spitlrr/ku-capstone.git
```
Change to project directory:
```bash
cd ku-capstone
```
Check that your local main branch is up to date:
```bash
git switch main
git pull
```
Creating new feature branches and switching branches:
```bash
git fetch --prune # remove stale branches
```
```bash
git branch -r # list remote branches
```
```bash
git switch -c feature/your-branch-name # create a new feature branch
```
```bash
git switch feature/existing-branch-name # switch to existing branch
```


#### *To contribute to this project, please see [CONTRIBUTING.md](CONTRIBUTING.md).*