param(
    [Parameter(Mandatory=$true)]
    [string]$Location,
    [string]$Output = 'TestSpeedResults.csv',
    [string[]]$WifiNames = @('Wi-Fi'),
    [string[]]$VpnNames = @('VPN')
)

# Installation of Ookla's speedtest CLI application is required before running this script. It must also be on the path and the license accepted.
# WifiNames is a list of connection aliases that you can configure in Control Panel\Network and Internet\Network Connections
# VpnNames is also a list of alias but will be tagged as a VPN connection

# Generate results file
if(!(Test-Path $Output)) {
    "Time,`"Wifi Name`",`"VPN Profile`",Location,`"Ping (ms)`",`"Download (Mbps)`",`"Upload (Mbps)`"" | Out-File $Output
}

# Get interfaces
$wifiProfiles = Get-NetConnectionProfile | ? { $WifiNames -contains $_.InterfaceAlias } | Select-Object -ExpandProperty Name
$vpnProfiles  = Get-NetConnectionProfile | ? { $VpnNames  -contains $_.InterfaceAlias } | Select-Object -ExpandProperty Name

# Get speed
$now = Get-Date
$hasError = $true
try {
    $sResult = speedtest.exe -f json
    $jResult = ConvertFrom-Json $sResult
    $hasError = $null -ne $jResult.error
}
catch {
    
}

# Check on success
if($hasError) {
    # Append error line to output
    $csvLine = "{0:G},`"{1}`",`"{2}`",{3},{4},{5},{6}" -f $now, $wifiProfiles, $vpnProfiles, $Location, `
        "", 0, 0

    $csvLine | Out-File $Output -Append
} else {
    # Append results to output
    $csvLine = "{0:G},`"{1}`",`"{2}`",{3},{4},{5},{6}" -f $now, $wifiProfiles, $vpnProfiles, $Location, `
        $jResult.ping.latency, ($jResult.download.bandwidth / 1000000.0 * 8.0), ($jResult.upload.bandwidth / 1000000.0 * 8.0)

    $csvLine | Out-File $Output -Append
}
