param resourceGroupName string = 'acr-app-rg'
param cosmosDbAccountName string = 'qademo-cd-rx-cosmosdb'
param alertRuleName string = 'COSMOS-RU-Alert'
param existingActionGroupName string = 'qademo-cd-rx-actiongroup'




resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: cosmosDbAccountName
}

resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}


resource alertResource 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: alertRuleName
  location: resourceGroup().location
  properties: {
    description: 'Alert on RU consumption greater than threshold for Azure Cosmos DB'
    severity: 3
    enabled: true
    scopes: [
      cosmosDbAccount.id
    ]
    criteria: {
      allOf: [
        {
          metricName: 'TotalRequestUnits'
          metricNamespace: 'Microsoft.DocumentDB/databaseAccounts'
          operator: 'GreaterThan'
          threshold: 10000  // Replace with your desired RU threshold
          timeAggregation: 'Maximum'
          dimensions: []
        }
      ]
    }
    actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
  }
}

output alertResourceId string = alertResource.id
