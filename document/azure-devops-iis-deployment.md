## 1. Azure DevOps Pipeline Setup

### Prerequisites
- Azure DevOps Project with Repos configured.
- A Windows Server VM with IIS, agent installed and configured as a self-hosted agent.
- IIS server has the target site and bindings set up in advance.

### Folder Structure (Repo)
```
/src/
  MyApp/
    MyApp.csproj
    Program.cs
    ...
/scripts/
  deploy.ps1
azure-pipelines.yml
```

---

### CI/CD YAML Pipeline (`azure-pipelines.yml`)

```yaml
trigger:
  branches:
    include:
      - main

variables:
  major: '1'
  minor: '0'
  hotfix: '0'
  buildNumber: $[counter(format('{0}.{1}.{2}', variables['major'], variables['minor'], variables['hotfix']), 1)]
  appVersion: '$(major).$(minor).$(hotfix).$(buildNumber)'

name: '$(appVersion)'

pool:
  name: 'self-hosted-windows'

stages:
  - stage: Build
    displayName: 'Build Stage'
    jobs:
      - job: BuildJob
        steps:
          - task: UseDotNet@2
            inputs:
              packageType: 'sdk'
              version: '7.0.x'

          - script: |
              echo "##[section]Update csproj with version"
              powershell ./scripts/update-csproj-version.ps1 -Path "src/MyApp/MyApp.csproj" -Version "$(appVersion)"
            displayName: 'Update Version in .csproj'

          - task: DotNetCoreCLI@2
            inputs:
              command: 'build'
              projects: 'src/MyApp/MyApp.csproj'
              arguments: '--configuration Release'

          - task: DotNetCoreCLI@2
            inputs:
              command: 'publish'
              publishWebProjects: true
              arguments: '--configuration Release --output $(Build.ArtifactStagingDirectory)'
              zipAfterPublish: true

          - task: PublishBuildArtifacts@1
            inputs:
              PathtoPublish: '$(Build.ArtifactStagingDirectory)'
              ArtifactName: 'drop'
              publishLocation: 'Container'

  - stage: Deploy
    displayName: 'Deploy Stage'
    dependsOn: Build
    jobs:
      - deployment: DeployToIIS
        environment: 'iis-prod'
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop

                - task: PowerShell@2
                  inputs:
                    targetType: 'filePath'
                    filePath: 'scripts/deploy.ps1'
                    arguments: '-AppPath "$(Pipeline.Workspace)\drop" -SiteName "MyWebApp"'
```

---

## 2. Version Management

### Script: `scripts/update-csproj-version.ps1`

```powershell
param(
    [string]$Path,
    [string]$Version
)

Write-Host "Setting version $Version in $Path"

[xml]$csproj = Get-Content $Path
$versionNode = $csproj.Project.PropertyGroup.Version

if (!$versionNode) {
    $newNode = $csproj.CreateElement("Version")
    $newNode.InnerText = $Version
    $csproj.Project.PropertyGroup.AppendChild($newNode) | Out-Null
} else {
    $versionNode.InnerText = $Version
}

$csproj.Save($Path)
```

---

## 3. IIS Deployment Script

### Script: `scripts/deploy.ps1`

```powershell
param(
    [string]$AppPath,
    [string]$SiteName
)

$dest = "C:\inetpub\wwwroot\$SiteName"

Write-Host "Stopping IIS Site: $SiteName"
Stop-WebSite -Name $SiteName

Write-Host "Clearing existing content"
Remove-Item "$dest\*" -Recurse -Force

Write-Host "Copying new content"
Expand-Archive "$AppPath\*.zip" -DestinationPath $dest -Force

Write-Host "Starting IIS Site: $SiteName"
Start-WebSite -Name $SiteName
```

---

## 4. Azure DevOps Setup Notes

- Configure a self-hosted agent with access to IIS and administrative privileges.
- Set up IIS site (`MyWebApp`) in advance or automate with DSC.
- Use service connections if deploying to Azure or using hosted agents.

---

## 5. Optional Enhancements

- Add `WebDeploy` tasks for hosted agents.
- Implement deployment approvals in the pipeline.
- Add Slack/MS Teams notifications for deployments.
- Integrate with Azure Monitor for post-deployment health checks.
- Use pipeline templates for modularization.

---

## 6. Deliverables Summary

| Deliverable           | Description                                      |
|-----------------------|--------------------------------------------------|
| `azure-pipelines.yml` | Complete build & deploy pipeline definition      |
| `update-csproj-version.ps1` | Script to inject version info into `.csproj` |
| `deploy.ps1`          | PowerShell script to deploy site to IIS          |
| Versioning Strategy   | CI pipeline increments version as `x.y.z.b`      |
| Docs                  | This markdown file serves as full documentation  |

---

## 7. Final Remarks

This setup supports continuous integration and deployment of .NET apps to IIS on Windows servers. It enforces version control, automation, and prepares for extension into advanced CI/CD use cases like Blue/Green deployments, slot-based swaps, or Azure App Service migration.
