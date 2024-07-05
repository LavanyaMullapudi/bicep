param subscriptionId string
param resourceGroupName string
param appServiceName string
param actionGroupName string = 'dev-rhythmx-new'

var scope = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${appServiceName}'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: resourceGroup().location
  properties: {
    groupShortName: 'actiongroup'
    emailReceivers: []
    // Add other receivers as needed
  }
}
resource alert 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: 'HighCPUAlert'
  location: 'Global'
  properties: {
    description: 'Alert triggered when CPU exceeds 70% for ${appServiceName}'
    severity: 3
    enabled: true
    criteria: {
     'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          metricName: 'CpuPercentage'
          dimensions: []
          operator: 'GreaterThan'
          threshold: 70
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
        actionGroup.id
    ]
  }
}

output alertId string = alert.id
