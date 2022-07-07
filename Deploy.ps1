winrm quickconfig -force # Configure the Agent to run DSC configurations
Install-Module Office365DSC -Force -AllowPrerelease # Install the Office365DSC module
&"D:\a\r1\a\_Showcase-CI\DSC\O365.ps1" # Execute the DSC Configuration script from the built artefacts