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

Start-DscConfiguration -Path $PSScriptRoot -Verbose -Wait -Force
 
if ($error.Count -gt 0)
{
    write-host "the following errors occurred during dsc configuration";
    write-host ($error | fl * | out-string );
    throw $error[-1];
}
