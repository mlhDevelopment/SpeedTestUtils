param(
    [int]$DelaySeconds = 60,
    [string]$Output = 'TestSpeedResults.csv',
    [string[]]$WifiNames = @('Wi-Fi'),
    [string[]]$VpnNames = @('VPN')
)

# Don't bother with prompting for the location in case the user moves around
# Create a session ID
$location = "Monitor {0:fffff}" -f (get-date)

# TODO implement this as a job and return it
while($true) {
    Write-Host '.' -NoNewline
    ./Test-Speed.ps1 -Location $location -Output $Output -WifiNames $WifiNames -VpnNames $VpnNames
    Start-Sleep -Seconds $DelaySeconds
}