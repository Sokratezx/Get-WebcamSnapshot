function Get-WebcamDevices {
    $output = & ffmpeg -hide_banner -f dshow -list_devices true -i dummy 2>&1
    $i = 1

    foreach ($line in $output) {
        if ($line -match '^\s*\[dshow[^\]]*\]\s*"([^"]+)"\s*\(video\)\s*$') {
            "{0}. {1}" -f $i, $Matches[1].Trim()
            $i++
        }
    }
}

function Get-WebcamSnapshot {
    param(
        [Parameter(Mandatory=$true)]
        [int]$DeviceNumber,

        [Parameter(Mandatory=$true)]
        [string]$OutFile
    )

    $output = & ffmpeg -hide_banner -f dshow -list_devices true -i dummy 2>&1
    $devices = @()

    foreach ($line in $output) {
        if ($line -match '^\s*\[dshow[^\]]*\]\s*"([^"]+)"\s*\(video\)\s*$') {
            $devices += $Matches[1].Trim()
        }
    }

    if ($devices.Count -eq 0) { throw "No webcams found." }

    $idx = $DeviceNumber - 1
    if ($idx -lt 0 -or $idx -ge $devices.Count) {
        throw "Invalid device number. Valid: 1..$($devices.Count)"
    }

    $deviceName = $devices[$idx]

    & ffmpeg -hide_banner -loglevel error `
        -f dshow -rtbufsize 200M -i "video=$deviceName" `
        -frames:v 1 -q:v 2 "$OutFile"
}
