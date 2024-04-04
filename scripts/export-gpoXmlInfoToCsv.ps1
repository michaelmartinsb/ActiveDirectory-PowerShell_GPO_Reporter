# Load the XML content from a file
[xml]$gpoXml = Get-Content -Path "C:\temp\gpoAnalysis\GPOReports\xml\Global - Software Installation - Microsoft .NET SDK 6.0.418 (x64).xml"

# Extracting key information with added detail
$gpoName = $gpoXml.GPO.Name
$domain = $gpoXml.GPO.Identifier.Domain
$gpoId = $gpoXml.GPO.Identifier.Identifier
$createdTime = $gpoXml.GPO.CreatedTime
$modifiedTime = $gpoXml.GPO.ModifiedTime
$readTime = $gpoXml.GPO.ReadTime
$commentsIncluded = $gpoXml.GPO.IncludeComments
$securityDescriptor = $gpoXml.GPO.SecurityDescriptor.SDDL
$owner = $gpoXml.GPO.SecurityDescriptor.Owner.Name
$ownerSID = $gpoXml.GPO.SecurityDescriptor.Owner.SID
$group = $gpoXml.GPO.SecurityDescriptor.Group.Name
$groupSID = $gpoXml.GPO.SecurityDescriptor.Group.SID
$permissions = $gpoXml.GPO.SecurityDescriptor.Permissions.TrusteePermissions | ForEach-Object {
    @{
        "Trustee" = $_.Trustee.Name
        "PermissionType" = $_.Type.PermissionType
        "Standard" = $_.Standard.GPOGroupedAccessEnum
        "ApplicabilityToSelf" = $_.Applicability.ToSelf
        "ApplicabilityToDescendantObjects" = $_.Applicability.ToDescendantObjects
        "ApplicabilityToDescendantContainers" = $_.Applicability.ToDescendantContainers
    }
}
$computerEnabled = $gpoXml.GPO.Computer.Enabled
$scriptCommand = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Command
$scriptType = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Type
$userEnabled = $gpoXml.GPO.User.Enabled
$linkTo = $gpoXml.GPO.LinksTo.SOMName
$linkPath = $gpoXml.GPO.LinksTo.SOMPath
$noOverride = $gpoXml.GPO.LinksTo.NoOverride

# Create an object for each GPO to export to CSV
$gpoObject = [PSCustomObject]@{
    GPOName = $gpoName
    Domain = $domain
    GPOId = $gpoId
    CreatedTime = $createdTime
    ModifiedTime = $modifiedTime
    ReadTime = $readTime
    CommentsIncluded = $commentsIncluded
    SecurityDescriptor = $securityDescriptor
    Owner = $owner
    OwnerSID = $ownerSID
    Group = $group
    GroupSID = $groupSID
    Permissions = ($permissions | ConvertTo-Json -Compress)
    ComputerConfigurationEnabled = $computerEnabled
    ScriptCommand = $scriptCommand
    ScriptType = $scriptType
    UserConfigurationEnabled = $userEnabled
    LinkedTo = $linkTo
    LinkPath = $linkPath
    NoOverride = $noOverride
}

# Specify the path to export the CSV file
$exportPath = "C:\temp\gpoAnalysis\GPOReports\GPOInformation2.csv"

# Export to CSV
$gpoObject | Export-Csv -Path $exportPath -NoTypeInformation
