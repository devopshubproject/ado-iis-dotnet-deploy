param(
    [string]$SiteName,
    [string]$PackagePath,
    [string]$IISServer,
    [string]$Username,
    [string]$Password
)

$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)

Invoke-Command -ComputerName $IISServer -Credential $cred -ScriptBlock {
    param($SiteName, $PackagePath)
    Import-Module WebAdministration
    $publishPath = "C:\inetpub\wwwroot\$SiteName"
    if (!(Test-Path $publishPath)) {
        New-Item -Path $publishPath -ItemType Directory
    }
    # Unzip and deploy
    Expand-Archive -Path $PackagePath -DestinationPath $publishPath -Force
    Restart-WebAppPool -Name "$SiteName"
} -ArgumentList $SiteName, $PackagePath