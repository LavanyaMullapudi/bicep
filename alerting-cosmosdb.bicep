param resourceGroupName string = 'acr-app-rg'
param cosmosDbAccountName string = 'qademo-cd-rx-cosmosdb'
// param alertRuleName string = 'COSMOS-RU-Alert'
param existingActionGroupName string = 'qademo-cd-rx-actiongroup'




resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: cosmosDbAccountName
 // location: 'EastUS2'
}

resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}

resource alertRule 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${cosmosDbAccountName}-HighRequestChargeAlert'
  location: 'Global'
  properties: {
    description: 'Alert triggered when request charge exceeds threshold'
    severity: 3 // 0 - 4 (from lowest to highest severity)
    isEnabled: true
    actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
    condition: {
      metricName: 'RequestCharge'
      metricNamespace: 'Microsoft.DocumentDB/databaseAccounts'
      operator: 'GreaterThan'
      threshold: 1000 // Example threshold (adjust as needed)
      timeAggregation: 'Average'
      metricTriggerType: 'MetricThreshold'
      dimensions: [
        {
          name: 'DatabaseAccountName'
          operator: 'Include'
          values: [
            cosmosDbAccountName
          ]
        }
      ]
    }
  }
}

/*
resource alertResource 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: alertRuleName
  location: 'Global'
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
     'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
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
*/
// output alertResourceId string = alertRule.id
