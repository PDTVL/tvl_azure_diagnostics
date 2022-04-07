
Login-AzAccount
$csvFile = "AuditData.csv"
$csv = Import-Csv $csvFile -Delimiter ','
#$csvNames=$csv | Select-Object -Property ResourceName -Unique
foreach ($resource in $csv) {
    $resourceId=$resource.ResourceId
    #write-host "Setting resource $resourceID"
    $DiagnosticSettingName = $resource.ResourceName -replace('/','_')
    $DiagnosticSettingName="$($DiagnosticSettingName)-to-eh-alertlogicingest".ToLower()
    $auditSettings = New-AzDiagnosticDetailSetting -Log -Category $resource.DiagnosticName -Enabled
    #write-host "$auditSettings = New-AzDiagnosticDetailSetting -Log -Category $resource.DiagnosticName -Enabled"
    $setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $resourceId -EventHubName "insights-operational-logs" -EventHubAuthorizationRuleId "/subscriptions/2dea4bce-701a-417e-9adf-78159bd3c6e2/resourceGroups/AZCENNERGAL02/providers/Microsoft.EventHub/namespaces/AlertLogicIngest-northeurope-ngfjgcaseooyc/authorizationrules/RootManageSharedAccessKey" -Setting $auditSettings
    #write-host "$setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $resourceId -EventHubName "AlertLogicIngest-northeurope-ngfjgcaseooyc" -EventHubAuthorizationRuleId "/subscriptions/2dea4bce-701a-417e-9adf-78159bd3c6e2/resourceGroups/AZCENNERGAL02/providers/Microsoft.EventHub/namespaces/AlertLogicIngest-northeurope-ngfjgcaseooyc/authorizationrules/RootManageSharedAccessKey" -Setting $auditSettings"
    Set-AzDiagnosticSetting -InputObject $setting
    #write-host "Set-AzDiagnosticSetting -InputObject $setting"

}
