@{
    AllNodes    = @(
        @{
            NodeName                    = 'localhost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        }
    )
    NonNodeData = @{
        HRSiteCol = @{
            Url   = 'https://ykuijs.sharepoint.com/sites/hr'
            Owner = 'admin@ykuijs.onmicrosoft.com'
        }
    }
}