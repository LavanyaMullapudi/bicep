param subscriptionId string
param resourceGroupName string
param appServiceName string

var scope = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${appServiceName}'

resource alert 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: 'HighCPUAlert'
  location: 'Global'
  properties: {
    description: 'Alert triggered when CPU exceeds 70% for ${appServiceName}'
    severity: 3
    enabled: true
    criteria: {
       odata.type: 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          metricName: 'CpuPercentage'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 70
          timeAggregation: 'Average'
          dimensions: []
        }
      ]
    }
    actions: []
  }
}

output alertId string = alert.id
