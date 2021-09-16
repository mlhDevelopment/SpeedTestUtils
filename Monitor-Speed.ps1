param(
    [int]$DelaySeconds = 60,
    [string]$Output = 'TestSpeedResults.csv',
    [string[]]$WifiNames = @('Wi-Fi'),
    [string[]]$VpnNames = @('VPN'),
    [switch]$AsJob = $false
)

# Don't bother with prompting for the location in case the user moves around
# Create a session ID
$sessionId = (get-date).ToString("fffff")
$location = "Monitor $sessionId"

if($AsJob) {
    $job = Start-Job -Name "Monitor-Speed $sessionId" -ScriptBlock { 
        while($true) {
            ./Test-Speed.ps1 -Location $location -Output $Output -WifiNames $WifiNames -VpnNames $VpnNames
            Start-Sleep -Seconds $DelaySeconds
        }
    }
    $job
} else {
    while($true) {
        Write-Host '.' -NoNewline
        ./Test-Speed.ps1 -Location $location -Output $Output -WifiNames $WifiNames -VpnNames $VpnNames
        Start-Sleep -Seconds $DelaySeconds
    }
}