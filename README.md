# .NET IIS Deployment on Azure DevOps

## 📦 Overview

This project provides a complete solution for deploying .NET applications to IIS servers using Azure DevOps. It automates build, test, and deployment processes, and includes infrastructure configuration and database integration.

---

## 🧱 Architecture

- **Source Control:** GitHub repository for code and workflow management.
- **CI/CD:** Azure DevOps pipelines automate build, test, and deployment.
- **Deployment Target:** IIS server (Azure VM or self-hosted agent).
- **Automation:** PowerShell scripts for remote deployment, Ansible for server configuration.
- **Database:** Azure SQL Server for persistent data storage.

---

## 🗺️ Architecture Diagram

![Architecture Diagram](./docs/architecture.png)

_This diagram shows the high-level architecture, including source control, CI/CD, deployment targets, and supporting infrastructure._

---

## 🏗️ Pipeline Flow

![Pipeline Flow](./docs/pipeline-flow.png)

_This diagram illustrates the end-to-end CI/CD pipeline, from code commit to deployment and database update._

---

## 🚀 Features

- Automated build and deployment pipeline
- Remote IIS deployment via PowerShell
- Infrastructure configuration with Ansible
- Integration with Azure SQL Server
- GitHub Actions for repository triggers

---

## 🛠️ Prerequisites

- Azure DevOps account and project
- Azure subscription (for VM and SQL Server)
- IIS server (Azure VM or on-premises)
- Service connection between Azure DevOps and Azure
- GitHub repository access
- [Optional] Ansible installed for configuration management

---

## ⚙️ Setup & Configuration

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 2. Configure Azure DevOps Pipeline

- Import the provided YAML pipeline into your Azure DevOps project.
- Set up required pipeline variables (e.g., server IP, credentials, etc.).
- Create service connections for Azure and GitHub.

### 3. Prepare IIS Server

- Ensure IIS is installed and configured on your target VM.
- Open necessary firewall ports (e.g., 80, 443).
- [Optional] Use the provided Ansible playbooks to automate server setup.

### 4. Database Setup

- Provision an Azure SQL Server instance.
- Update connection strings in your application configuration.

### 5. PowerShell Deployment Script

- Review and customize the PowerShell script for your environment.
- Ensure the script has permissions to deploy to the IIS server.

---

## 🏗️ CI/CD Pipeline Overview

1. **Code Commit:** Push code to GitHub.
2. **Trigger:** GitHub Workflow triggers Azure DevOps pipeline.
3. **Build:** Azure DevOps builds the .NET application.
4. **Test:** Automated tests are executed.
5. **Deploy:** PowerShell script deploys the app to IIS server.
6. **Configure:** Ansible playbooks apply additional server configuration.
7. **Database:** Migrations/scripts update Azure SQL Server as needed.

---

## 📂 Project Structure

```
ado-iis-dotnet-deploy/
│
├── .github/workflows/         # GitHub Actions workflows
├── azure-pipelines.yml        # Azure DevOps pipeline definition
├── scripts/
│   └── deploy.ps1             # PowerShell deployment script
├── ansible/
│   └── playbook.yml           # Ansible playbook for server config
├── src/                       # .NET application source code
├── docs/
│   ├── architecture.png       # Architecture diagram
│   └── pipeline-flow.png      # Pipeline flow diagram
├── README.md                  # Project documentation
└── ...
```

---

## 📝 Usage

1. Push your code to the repository.
2. The pipeline will automatically build, test, and deploy your application.
3. Monitor pipeline status in Azure DevOps.
4. Access your application via the IIS server's public IP or DNS.

---

## 🧩 Customization

- **Pipeline Variables:** Adjust variables in the pipeline for your environment.
- **PowerShell Script:** Modify deployment logic as needed.
- **Ansible Playbooks:** Extend for additional server roles or configuration.

---

## 🛡️ Security

- Store secrets (e.g., credentials, connection strings) in Azure DevOps secure variables or Azure Key Vault.
- Restrict access to deployment scripts and sensitive files.

---

## 🧑‍💻 Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/license/MIT). See the LICENSE file for details.

---

## 🌐 Follow Me

[![Portfolio](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/premkumar-palanichamy)
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCJKEn6HeAxRNirDMBwFfi3w)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/premkumarpalanichamy)

---

## 📬 Contact

For questions or support, please open an issue or contact [premkumarpalanichamy](https://github.com/premkumar-palanichamy).