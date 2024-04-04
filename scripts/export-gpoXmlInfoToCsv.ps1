# Load the XML content from a file
[xml]$gpoXml = Get-Content -Path "C:\temp\gpoAnalysis\GPOReports\xml\Global - Software Installation - Microsoft .NET SDK 6.0.418 (x64).xml"

# Extracting key information
$gpoName = $gpoXml.GPO.Name
$domain = $gpoXml.GPO.Identifier.Domain
$gpoId = $gpoXml.GPO.Identifier.Identifier
$createdTime = $gpoXml.GPO.CreatedTime
$modifiedTime = $gpoXml.GPO.ModifiedTime
$securityDescriptor = $gpoXml.GPO.SecurityDescriptor.SDDL
$owner = $gpoXml.GPO.SecurityDescriptor.Owner.Name
$permissions = $gpoXml.GPO.SecurityDescriptor.Permissions.TrusteePermissions | ForEach-Object {
    @{
        "Trustee" = $_.Trustee.Name
        "PermissionType" = $_.Type.PermissionType
        "Standard" = $_.Standard.GPOGroupedAccessEnum
    }
}
$linkTo = $gpoXml.GPO.LinksTo.SOMName
$scriptCommand = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Command
$scriptType = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Type

# Create an object for each GPO to export to CSV
$gpoObject = [PSCustomObject]@{
    GPOName = $gpoName
    Domain = $domain
    GPOId = $gpoId
    CreatedTime = $createdTime
    ModifiedTime = $modifiedTime
    SecurityDescriptor = $securityDescriptor
    Owner = $owner
    Permissions = ($permissions | ConvertTo-Json -Compress)
    LinkedTo = $linkTo
    ScriptCommand = $scriptCommand
    ScriptType = $scriptType
}

# Export to CSV
$gpoObject | Export-Csv -Path "C:\temp\gpoAnalysis\GPOReports\GPOInformation.csv" -NoTypeInformation
