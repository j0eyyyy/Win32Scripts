$LogFile = "C:\Windows\Temp\CopyFiless_Install.log"
$TargetFolder = ""
$SourceFolder = $PSScriptRoot

# Delete any existing logfile if it exists
If (Test-Path $LogFile){Remove-Item $LogFile -Force -ErrorAction SilentlyContinue -Confirm:$false}

Function Write-Log{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message
    )

    $TimeGenerated = $(Get-Date -UFormat "%D %T")
    $Line = "$TimeGenerated : $Message"
    Add-Content -Value $Line -Path $LogFile -Encoding Ascii
}

Write-Log "Starting the copyfolder installer"

# Make sure target folder exists
If (!(Test-Path $TargetFolder)){ 
    Write-Log "Target folder $TargetFolder does not exist, creating it"
    New-Item -Path $TargetFolder -ItemType Directory -Force
}

# Copy the folder
Write-Log "About to copy contents from $SourceFolder to $TargetFolder"
try {
    Copy-Item -Path "$SourceFolder\*" -Destination $TargetFolder -Recurse -Force -Exclude *.ps1 -ErrorAction Stop 
    Write-Log "Contents of $SourceFolder successfully copied to $TargetFolder"
} 
catch {
    Write-Log "Failed to copy $SourceFolder to $TargetFolder. Error is: $($_.Exception.Message))"
}
  
