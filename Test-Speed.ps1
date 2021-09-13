param(
    [Parameter(Mandatory=$true)]
    [string]$Location,
    [string]$Output = 'TestSpeedResults.csv'
)

# Installation of Ookla's speedtest CLI application is required before running this script. It must also be on the path and the license accepted.

# Generate results file
if(!(Test-Path $Output)) {
    "Time,`"Wifi Profile`",Location,`"Ping (ms)`",`"Download (bps)`",`"Upload (bps)`"" | Out-File $Output
}

# Get interfaces
$profile = Get-NetConnectionProfile | ? { $_.InterfaceAlias -eq 'Wi-Fi' } | Select-Object -ExpandProperty Name

# Get speed
$now = Get-Date
$sResult = speedtest.exe -f json
$jResult = ConvertFrom-Json $sResult

if($jResult.download.bandwidth -eq $null) {
    "Oops"
    $global:result = $sResult
}


# Append to output
$csvLine = "{0:g},`"{1}`",`"{2}`",{3},{4},{5}" -f $now, $profile, $Location, $jResult.ping.latency, $jResult.download.bandwidth, $jResult.upload.bandwidth

$csvLine | Out-File $Output -Append
