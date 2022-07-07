Configuration O365
{
    Import-DscResource -ModuleName Microsoft365DSC
    $password = ConvertTo-SecureString 'password' -AsPlainText -Force
    $GlobalAdmin = New-object System.Management.Automation.PSCredential ('username', $password)

    Node instance-2
    {
        # Add code changes
        TeamsTeam 'ConfigureTeam'
        {
            DisplayName                       = "Sample3"
            Description                       = "Sample"
            Visibility                        = "Private"
            MailNickName                      = "DSCTeam2"
            AllowUserEditMessages             = $false
            AllowUserDeleteMessages           = $false
            AllowOwnerDeleteMessages          = $false
            AllowTeamMentions                 = $false
            AllowChannelMentions              = $false
            allowCreateUpdateChannels         = $false
            AllowDeleteChannels               = $false
            AllowAddRemoveApps                = $false
            AllowCreateUpdateRemoveTabs       = $false
            AllowCreateUpdateRemoveConnectors = $false
            AllowGiphy                        = $True
            GiphyContentRating                = "strict"
            AllowStickersAndMemes             = $True
            AllowCustomMemes                  = $True
            AllowGuestCreateUpdateChannels    = $true
            AllowGuestDeleteChannels          = $true
            Ensure                            = "Present"
            Credential                        = $GlobalAdmin
        }
    
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName                    = "instance-2"
            PsDSCAllowPlaintextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

#$ConfigData = @{...}
#Write-Log -Message 'Setting up WinRM'
#winrm quickconfig -force -quiet
O365 -ConfigurationData $ConfigData
Start-DscConfiguration O365 -Wait -Verbose -Force