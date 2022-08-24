function Write-Log
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "$timestamp - $Message"
}

Write-Log -Message 'Checking for presence of Microsoft365Dsc module and all required modules'
Write-Log -Message ' '

$modules = Import-PowerShellDataFile -Path '.\DscResources.psd1'

$workingDirectory = $PSScriptRoot

if ($modules.ContainsKey("Microsoft365Dsc"))
{
    Write-Log -Message 'Checking Microsoft365Dsc version'
    $psGalleryVersion = $modules.Microsoft365Dsc
    $localModule = Get-Module 'Microsoft365Dsc' -ListAvailable

    Write-Log -Message "- Required version: $psGalleryVersion"
    Write-Log -Message "- Installed version: $($localModule.Version)"
    Write-Log -Message ' '

    if ($localModule.Version -ne $psGalleryVersion)
    {
        Write-Log -Message 'Incorrect version installed. Removing current module.'
        foreach ($requiredModule in $localModule.RequiredModules)
        {
            $requiredModulePath = Join-Path -Path 'C:\Program Files\WindowsPowerShell\Modules' -ChildPath $requiredModule.Name
            Remove-Item -Path $requiredModulePath -Force -Recurse -ErrorAction 'SilentlyContinue'
        }

        Write-Log -Message 'Installing Microsoft365Dsc and required modules'
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
        Install-Module -Name 'Microsoft365Dsc' -RequiredVersion $psGalleryVersion -AllowClobber

        Write-Log -Message 'Modules installed successfully!'
        Write-Log -Message ' '
    }
    else
    {
        Write-Log -Message 'Correct version installed, continuing.'
        Write-Log -Message ' '
    }
}
else
{
    Write-Log "[ERROR] Unable to find Microsoft365Dsc in DscResources.psd1. Cancelling!"
    exit
}

Write-Log -Message 'Compiling configuration to MOF'

$outputFolder = Join-Path -Path $workingDirectory -ChildPath 'Output'

Write-Log -Message 'Loading configuration'
. .\M365Configuration_cert.ps1

if (-not (Test-Path -Path $outputFolder))
{
    $null = New-Item -Path $outputFolder -ItemType 'Directory'
}

Write-Log -Message 'Start compilation'
$null = ConfigureMicrosoft365 -ConfigurationData .\M365ConfigurationData.psd1 -OutputPath $outputFolder

Copy-Item -Path 'DscResources.psd1' -Destination $outputFolder
Copy-Item -Path 'deploy_cert.ps1' -Destination $outputFolder
