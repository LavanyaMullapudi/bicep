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

resource cosmosRUAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${cosmosDbAccountName}-HighRequestChargeAlert'
  location: 'Global'
  properties: {
     actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
    autoMitigate: true
        criteria: {
      allOf: [
        {
          name: 'Metric1'
          metricName: 'TotalRequestUnits'
          metricNamespace: 'Microsoft.DocumentDB/databaseAccounts'
          operator: 'GreaterThan'
          threshold: 10000  // Replace with your desired RU threshold
          timeAggregation: 'Maximum'
          criterionType: 'StaticThresholdCriterion'	
          dimensions: []
        }
      ]
     'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Alert on RU consumption greater than threshold for Azure Cosmos DB'
    severity: 3
    enabled: true
    scopes: [
      cosmosDbAccount.id
    ]

   
    evaluationFrequency: 'PT5M'
    targetResourceType: 'Microsoft.DocumentDB/databaseAccounts'
    windowSize: 'PT5M'
  }
}

resource cosmos429Alert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${cosmosDbAccountName}-HighRequestChargeAlert'
  location: 'Global'
  properties: {
     actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
    autoMitigate: true
        criteria: {
      allOf: [
        {
          name: 'Metric1'
          metricName: 'Requests'
          metricNamespace: 'Microsoft.DocumentDB/databaseAccounts'
          operator: 'GreaterThan'
          threshold: 3 // Example threshold (adjust as needed)
          timeAggregation: 'Count'
          metricTriggerType: 'MetricThreshold'
          criterionType: 'StaticThresholdCriterion'	
          dimensions: [
               name: 'StatusCode'
               operator: 'Include'
               values: [
              '429'
          ]
         ]
        }
      ]
     'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Alert triggered when 429 (Request Rate Too Large) errors exceed threshold'
    severity: 3
    enabled: true
    scopes: [
      cosmosDbAccount.id
    ]

   
    evaluationFrequency: 'PT5M'
    targetResourceType: 'Microsoft.DocumentDB/databaseAccounts'
    windowSize: 'PT5M'
  }
}


// output alertResourceId string = alertRule.id
