# Task on Terraform Topic

Write Terraform code that configures the GitHub repository according to the following requirements, execute it and save your Terraform code in a repository secret named `TERRAFORM`.

1. The GitHub repository should assign user `softservedata` as a collaborator.

2. A branch named `develop` should be created as default branch.

3. Protect the `main` and `develop` branches according to these rules:
- a user cannot merge into both branches without a pull request
- merging into the `develop` branch is allowed only if there are two approvals
- merging into the `main` branch is allowed only if the owner has approved the pull request
- assign the user `softservedata` as the code owner for all the files in the `main` branch
4. A pull request template (pull_request_template.md) should be added to the `.github` directory to allow users to create an issue in the required format:

## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update

5. A deploy key named `DEPLOY_KEY` should be added to the repository.

6. Create a Discord server and enable notifications when a pull request is created.

7. For GitHub actions, perform the following: 
- create PAT (Personal Access Token) with **Full control of private repositories** and **Full control of orgs and teams, read and write org projects**
- add the PAT to the repository actions secrets key with the name `PAT` and the value of the created PAT.

---

## ✅ Solution

This repository contains a complete Terraform solution that automates all the requirements above.

### 📁 Structure

```
src/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Input variables definition
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example configuration file
├── .gitignore                # Ignore sensitive files
├── setup.sh                   # Automated setup script
├── README.md                  # Detailed documentation
└── QUICKSTART.md             # Quick start guide
```

### 🚀 Quick Start

1. **Navigate to the src directory:**
   ```bash
   cd src
   ```

2. **Follow the Quick Start Guide:**
   ```bash
   cat QUICKSTART.md
   ```

3. **Or use the automated setup:**
   ```bash
   ./setup.sh
   ```

### 📋 What Gets Configured

- ✅ **Collaborator**: Adds `softservedata` with push access
- ✅ **Branches**: Creates `develop` and sets it as default
- ✅ **Branch Protection**: 
  - `main`: Requires PR + owner approval + code owner review
  - `develop`: Requires PR + 2 approvals
- ✅ **CODEOWNERS**: Assigns `softservedata` as code owner for all files
- ✅ **PR Template**: Creates `.github/pull_request_template.md`
- ✅ **Deploy Key**: Adds SSH deploy key named `DEPLOY_KEY`
- ✅ **Discord Webhook**: Configures PR notifications to Discord
- ✅ **Secrets**: Adds `PAT` and `TERRAFORM` to repository secrets

### 📚 Documentation

- **[QUICKSTART.md](src/QUICKSTART.md)** - Step-by-step quick start guide
- **[README.md](src/README.md)** - Comprehensive documentation with troubleshooting

### 🔧 Prerequisites

1. Terraform (1.0+)
2. GitHub Personal Access Token with appropriate permissions
3. Discord webhook URL
4. SSH key pair for deploy key

### 💡 Usage

Detailed instructions are available in the `src` directory. The solution includes:
- Automated setup script for easy deployment
- Example configuration files
- Comprehensive error handling
- Step-by-step manual instructions

For detailed setup instructions, see [src/README.md](src/README.md) or [src/QUICKSTART.md](src/QUICKSTART.md).
