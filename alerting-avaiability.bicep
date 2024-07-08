param subscriptionId string = '89a1afbb-99a3-4844-a9b3-55d84d47f784'
param existingActionGroupName string = ''
resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}

resource HealthStatus 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
name: 'HealthStatusAlert'
type: 'Microsoft.Insights/ActivityLogAlerts'
    location: 'global'
    tags: {}
    properties: {
        scopes: [
            '/subscriptions/subscriptionId'
        ]
            condition: {
            allOf: [
                {
                    field: 'category'
                    equals: 'ResourceHealth'
                }
                {
                    anyOf: [
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/6c94cfbe-a082-4e59-8d0b-48b5c7df4bef/resourceGroups/stg-platform-rg/providers/Microsoft.ApiManagement/service/stg-platform-apims'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-aiagent'
                            
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-aichat'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-ehreventwebhook'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-insights'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-patient'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-prompt-mgrservices'
                        }
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-vectormgr'
                        }
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-aiagent-listener'
                        }
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.Web/sites/qademo-cd-rx-fhir-fapp'
                        }

                        /*
                        {
                            field: 'resourceId'
                            equals: 'app gateway resource id'
                        }
                        */
                        {
                            field: 'resourceId'
                            equals: 'subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.DocumentDB/databaseAccounts/qademo-cd-rx-cosmosaccount'
                        }
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/6c94cfbe-a082-4e59-8d0b-48b5c7df4bef/resourceGroups/stg-clinical-rg/providers/Microsoft.KeyVault/vaults/stg-clinical-keyvt'
                        }
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.KeyVault/vaults/qademo-cd-rx-keyvt'
                        }
                        {
                            field: 'resourceId'
                            equals: '/subscriptions/2ccd7194-a3a9-4a4b-83a7-2c5a31fab05e/resourceGroups/qademo-cd-rx-rg/providers/Microsoft.AppConfiguration/configurationStores/qademo-cd-rx-appconfig'
                        }
                       
                    ]
                }
                {
                    anyOf: [
                      
                        {
                            field: 'resourceType'
                            equals: 'Microsoft.Web/sites'
                        }
                        {
                            field: 'resourceType'
                            equals: 'Microsoft.Network/applicationGateways'
                        }
                        {
                            field: 'resourceType'
                            equals: 'Microsoft.DocumentDB/databaseAccounts'
                        }
                        {
                            field: 'resourceType'
                            equals: 'Microsoft.KeyVault/vaults'
                        }
                           {
                            field: 'resourceType'
                            equals: 'Microsoft.AppConfiguration/configurationStores'
                        }
                    
                    ]
                }
            ]
        }
        actions: {
            actionGroups: [
                {
                    actionGroupId: ActionGroupName.id
                    webhookProperties: {}
                }
            ]
        }
        enabled: true
        description: 'One of the Resources is unhealthy'
    }
}
