Configuration ConfigureMicrosoft365
{
    param
    ()

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOTenantSettings 'TenantSettings'
        {
            IsSingleInstance                              = "Yes"
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
            FilePickerExternalImageSearchEnabled          = $true
            HideDefaultThemes                             = $false
            LegacyAuthProtocolsEnabled                    = $true
            MarkNewFilesSensitiveByDefault                = "AllowExternalSharing"
            MaxCompatibilityLevel                         = "15"
            MinCompatibilityLevel                         = "15"
            NotificationsInSharePointEnabled              = $true
            OfficeClientADALDisabled                      = $false
            OwnerAnonymousNotification                    = $true
            PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
            PublicCdnEnabled                              = $false
            SearchResolveExactEmailOrUPN                  = $false
            SignInAccelerationDomain                      = ""
            UseFindPeopleInPeoplePicker                   = $false
            UsePersistentCookiesForExplorerView           = $false
            UserVoiceForFeedbackEnabled                   = $true
            ApplicationId                                 = '<applicationid>'
            TenantId                                      = '<tenant>.onmicrosoft.com'
            CertificateThumbprint                         = '<thumbprint>'
        }
    }
}

