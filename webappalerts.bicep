param subscriptionId string
param resourceGroupName string
param appServiceName string
param actionGroupName string = 'dev-rhythmx-new'

var scope = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${appServiceName}'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: 'actiongroup'
    emailReceivers: []
    // Add other receivers as needed
  }
}
resource appServiceResource 'Microsoft.Web/sites@2021-02-01' existing = {
  name: appServiceName
  resourceGroup: resourceGroupName
}

resource alert 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: '${appServiceName}-HighCPUAlert'
  location: 'global'

  properties: {
        actions: [
      {
        actionGroupId: actionGroup.id
     }
     ]
    autoMitigate: true
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          metricName: 'CpuPercentage'
          dimensions: []
          operator: 'GreaterThan'
          threshold: 70
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    description: 'Alert triggered when CPU exceeds 70% for ${appServiceName}'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      appServiceResource.id

    ]
     severity: 3
     windowSize: 'PT1M'
     targetResourceRegion: 'global'
     targetResourceType: 'Microsoft.Web/sites'
  }
}

output alertId string = alert.id
