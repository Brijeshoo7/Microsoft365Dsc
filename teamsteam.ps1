Configuration TeamsTeam
{
    
    $password = ConvertTo-SecureString "password" -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ("username", $password)

    Import-DscResource -ModuleName Microsoft365DSC
    node instance-2
    {
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
            Ensure                            = "Absent"
            Credential                        = $Cred
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

teamsteam -ConfigurationData $ConfigData
Start-DscConfiguration teamsteam -Wait -Verbose -Force
