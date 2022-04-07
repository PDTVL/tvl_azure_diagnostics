# #Diagnostics

# If ($null -eq (Get-Command -Name Get-CloudDrive -ErrorAction SilentlyContinue)) {
#     If ($null -eq (Get-Module Az -ListAvailable -ErrorAction SilentlyContinue)){
#         Write-Host "Installing Az module from default repository"
#         Install-Module -Name Az -AllowClobber
#     }
#     Write-Host "Importing Az"
#     Import-Module -Name Az
#     Write-Host "Connecting to Az"
#     Connect-AzAccount
# }
# Get all Azure Subscriptions
Connect-AzAccount
$Subs = Get-AzSubscription
# Set array
$AuditResults = @()
# Loop through all Azure Subscriptions
foreach ($Sub in $Subs) {
    Set-AzContext $Sub.id | Out-Null
    #Write-Host "Processing Subscription:" $($Sub).name
    # Get all Azure resources for current subscription
    $Resources = Get-AZResource
    # Get all Azure resources which have Diagnostic settings enabled and configured
    foreach ($res in $Resources) {
        $resId = $res.ResourceId
        write-host $resId
        #write-host $resId
        $DiagSettings =  Get-AzDiagnosticSettingCategory -TargetResourceId $resId
        foreach ($diag in $DiagSettings) {
            if ($diag.Name -like '*Audit*') {
                write-host $Sub.Name $res.Name "with Resource ID:" $resId "Audit Property:" $diag.Name $diag.Logs "Region" $res.Location
            
            $item = [PSCustomObject]@{
                ResourceName = $res.name
                Location = $res.Location
                Subscription = $Sub.Name
                ResourceId = $resId
                DiagnosticName = $diag.Name
                WorkspaceName = $diag.WorkspaceId
                DiagnosticLogs = $diag.Logs
            }
            Write-Host $item
            $AuditResults += $item
        
            }
 

        }
    }
}

$AuditResults | Export-Csv -Force -Path ".\AzureResourceLogAudit-$(get-date -f yyyy-MM-dd-HHmm).csv"

