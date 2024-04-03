# Import the GroupPolicy module if not already loaded
Import-Module GroupPolicy

# Directory to save the GPO reports
$reportDir = "C:\temp\gpoAnalysis\GPOReports"

# Check if the directory exists; if not, create it
if (-not (Test-Path -Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir
}

# Retrieve all GPOs in the current domain
$gpos = Get-GPO -All

foreach ($gpo in $gpos) {
    # Sanitize the GPO DisplayName to remove characters not allowed in file names
    $safeName = $gpo.DisplayName -replace '[\\/:*?"<>|]', '_'
    # Ensure the report file name does not exceed 255 characters
    $safeName = if ($safeName.Length -gt 250) { $safeName.Substring(0, 250) } else { $safeName }

    # Define the report file name and path
    $reportPath = Join-Path -Path $reportDir -ChildPath ("$safeName.xml")

    # Attempt to generate the GPO report in XML format and save to file
    try {
        Write-Output "Attempting to generate report for GPO: $($gpo.DisplayName)"
        Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $reportPath
        Write-Output "Successfully generated report for GPO: $($gpo.DisplayName)"
    } catch {
        Write-Warning "Failed to generate report for GPO: $($gpo.DisplayName)"
        Write-Warning "Error: $_"
    }

    # Pause between each GPO report generation to avoid potential throttling or resource contention
    Start-Sleep -Seconds 1
}

Write-Output "All GPO reports have been attempted to be generated in the directory: $reportDir"
