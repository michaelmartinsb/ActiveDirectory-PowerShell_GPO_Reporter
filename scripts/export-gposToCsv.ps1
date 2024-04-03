# Import the GroupPolicy module if not already loaded
Import-Module GroupPolicy

# Retrieve all GPOs in the current domain
$gpos = Get-GPO -All

# Create an array to hold GPO data
$gpoData = @()

foreach ($gpo in $gpos) {
    # For each GPO, create a custom object with desired properties
    $gpoDetails = [PSCustomObject]@{
        Name        = $gpo.DisplayName
        ID          = $gpo.Id
        Status      = $gpo.GpoStatus
        #// Add more fields as needed
    }

    # Add the details to the array
    $gpoData += $gpoDetails
}

# Export the array to a CSV file
$gpoData | Export-Csv -Path ".\GPODocumentation.csv" -NoTypeInformation
