Quick tool to get a Webcam Snapshot via Powershell

1. Import ps1:
. .\snapshot.ps1
2. List Webcam Devices:
Get-WebcamDevices
3. Take Snapshot
Get-WebcamSnapshot DEVICE_NUMBER OUTPUT_FILE
