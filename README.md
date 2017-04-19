Get-RemoteEndPointGeolocations is a PowerShell script that lists the active TCP connections on a Windows system, along with the country and city in which the remote end point IP address is registered in.

The script is intended for use in recon/triage or by those interested in seeing where their machine is connecting to.

PowerShell and .NET 2.0 and above are required.

The script can easily be adapted to run across multiple machines remote. It can also be adapted to resolve geolocations against a subscriber service that provides ISP/organisation information.

# Usage
Save the script locally and execute with the following:
```
powershell .\Get-RemoteEndPointGeolocations.ps1
```

# Limitations
* Geolocations are obtained via freegeoip.net. Please respect their limits of 15,000 queries per hour. A (rather crude) address filter ensures private-space IP addresses are not sent for geolocation.
* Uses publicly-available IP address data which may be incorrect - IP addresses can be resold cross-border and it takes time for databases to be updated
* Connections hidden by a rootkit will not be visible in the results
