Function Get-RemoteEndPointGeolocations {
    [cmdletbinding()]
    param(
    )

    try {
        $Connections = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpConnections()
        foreach($Connection in $Connections) {
            if($Connection.LocalEndPoint.AddressFamily -eq "InterNetwork" ) { $IPType = "IPv4" } else { $IPType = "IPv6" }
            $Output = New-Object -TypeName PSobject
            $Output | Add-Member -MemberType NoteProperty -Name "LocalAddress" -Value $Connection.LocalEndPoint.Address
            $Output | Add-Member -MemberType NoteProperty -Name "LocalPort" -Value $Connection.LocalEndPoint.Port
            $Output | Add-Member -MemberType NoteProperty -Name "RemoteAddress" -Value $Connection.RemoteEndPoint.Address
            $Output | Add-Member -MemberType NoteProperty -Name "RemotePort" -Value $Connection.RemoteEndPoint.Port

            # Only send non-RFC-1918 addresses for Geo-location
            if($Output.RemoteAddress -notmatch "(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^127\.0\.0\.1)") {
                $remoteIp = $Connection.RemoteEndPoint.Address
                $response = (Invoke-WebRequest "http://158.69.242.138/json/$remoteIp").Content | ConvertFrom-Json
                $Output | Add-Member -MemberType NoteProperty -Name "RemoteCountry" -Value $response."country_name"
                $Output | Add-Member -MemberType NoteProperty -Name "RemoteCity" -Value $response."city"
            }

            $Output | Add-Member -MemberType NoteProperty -Name "State" -Value $Connection.State
            $Output | Add-Member -MemberType NoteProperty -Name "IPV4Or6" -Value $IPType
            $Output
        }

    } catch {
        Write-Error "Unable to get systems active connections. $_"
    }
}

Get-RemoteEndPointGeolocations | Format-Table