Function Get-RemoteEndPointGeolocations {
    [cmdletbinding()]
    param(
    )

    try {
        $Connections = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpConnections()
        foreach($Connection in $Connections) {
            $Hash = [ordered]@{}
            $Hash.LocalAddress  = $Connection.LocalEndPoint.Address
            $Hash.LocalPort     = $Connection.LocalEndPoint.Port
            $Hash.RemoteAddress = $Connection.RemoteEndPoint.Address
            $Hash.RemotePort    = $Connection.RemoteEndPoint.Port

            # Only send non-RFC-1918 addresses for Geo-location
            if($Output.RemoteAddress -notmatch "(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^127\.0\.0\.1)") {
                $remoteIp = $Connection.RemoteEndPoint.Address
                $response = (Invoke-WebRequest "http://www.freegeoip.net/json/$remoteIp").Content | ConvertFrom-Json
                $Hash.RemoteCountry = $response."country_name"
                $Hash.RemoteCity    = $response."city"
            } else {
                $Hash.RemoteCountry = $null
                $Hash.RemoteCity    = $null
            }

            $Hash.State         = $Connection.State
            $Hash.IPV4Or6       = if($Connection.LocalEndPoint.AddressFamily -eq "InterNetwork" ) { "IPv4" } else { "IPv6" }



            [pscustomobject]$Hash
        }

    } catch {
        Write-Error "Unable to get systems active connections. $_"
    }
}

Get-RemoteEndPointGeolocations | Format-Table 
