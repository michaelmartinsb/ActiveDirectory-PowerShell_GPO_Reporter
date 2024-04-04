# Load the XML content from a file
[xml]$gpoXml = Get-Content -Path "EnterPathHere"

# Correctly extracting information by accessing the text content of the XML elements
$gpoName = $gpoXml.GPO.Name
$domain = $gpoXml.GPO.Identifier.Domain.'#text'
$gpoId = $gpoXml.GPO.Identifier.Identifier.'#text'
$createdTime = $gpoXml.GPO.CreatedTime
$modifiedTime = $gpoXml.GPO.ModifiedTime
$readTime = $gpoXml.GPO.ReadTime
$commentsIncluded = $gpoXml.GPO.IncludeComments
$securityDescriptor = $gpoXml.GPO.SecurityDescriptor.SDDL.'#text'
$owner = $gpoXml.GPO.SecurityDescriptor.Owner.Name.'#text'
$ownerSID = $gpoXml.GPO.SecurityDescriptor.Owner.SID.'#text'
$group = $gpoXml.GPO.SecurityDescriptor.Group.Name.'#text'
$groupSID = $gpoXml.GPO.SecurityDescriptor.Group.SID.'#text'

# Parsing Permissions into a more readable format
$permissions = $gpoXml.GPO.SecurityDescriptor.Permissions.TrusteePermissions | ForEach-Object {
    @{
        "Trustee" = $_.Trustee.Name.'#text'
        "PermissionType" = $_.Type.PermissionType
        "Standard" = $_.Standard.GPOGroupedAccessEnum
        "ApplicabilityToSelf" = $_.Applicability.ToSelf
        "ApplicabilityToDescendantObjects" = $_.Applicability.ToDescendantObjects
        "ApplicabilityToDescendantContainers" = $_.Applicability.ToDescendantContainers
    }
} | ConvertTo-Json -Compress

$linkTo = $gpoXml.GPO.LinksTo.SOMName
$scriptCommand = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Command
$scriptType = $gpoXml.GPO.Computer.ExtensionData.Extension.Script.Type

# Create an object for each GPO to export to CSV, incorporating corrected fields
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
    Permissions = $permissions
    ComputerConfigurationEnabled = $gpoXml.GPO.Computer.Enabled
    ScriptCommand = $scriptCommand
    ScriptType = $scriptType
    UserConfigurationEnabled = $gpoXml.GPO.User.Enabled
    LinkedTo = $linkTo
    LinkPath = $gpoXml.GPO.LinksTo.SOMPath
    NoOverride = $gpoXml.GPO.LinksTo.NoOverride
}

# Export to CSV. Specify the path where you want to save the CSV file
$exportPath = "EnterPathHere\GPOInformation.csv"

$gpoObject | Export-Csv -Path $exportPath -NoTypeInformation
