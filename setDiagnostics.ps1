$resourceId="/subscriptions/0db2ffc4-c709-4d63-9e40-c9351a9b420b/resourceGroups/AZUATNERGKV01/providers/Microsoft.KeyVault/vaults/AZUATNEKVDS01"

$DiagnosticSettingName = "testDiagnosticsPaulDawson"

$auditSettings = New-AzDiagnosticDetailSetting -Log -Category "Audit" -Enabled

$setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $resourceId -EventHubName "AlertLogicIngest-northeurope-ngfjgcaseooyc" -EventHubAuthorizationRuleId "/subscriptions/2dea4bce-701a-417e-9adf-78159bd3c6e2/resourceGroups/AZCENNERGAL02/providers/Microsoft.EventHub/namespaces/AlertLogicIngest-northeurope-ngfjgcaseooyc/authorizationrules/RootManageSharedAccessKey" -Setting $auditSettings

Set-AzDiagnosticSetting -InputObject $setting

