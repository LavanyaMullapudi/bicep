param subscriptionId string
param resourceGroupName string
param appServiceName string
param actionGroupName string = 'dev-rhythmx-new'

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
}

resource alert 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: '${appServiceName}-HighCPUAlert'
  location: 'global'
  properties: {
    description: 'Alert triggered when CPU exceeds 70% for ${appServiceName}'
    severity: 3
    enabled: true // Ensure this property is included
    evaluationFrequency: 'PT1M'
    windowSize: 'PT1M'
    targetResourceRegion: 'global'
    targetResourceType: 'Microsoft.Web/sites'
    scopes: [
      appServiceResource.id
    ]
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
    actions: [
      {
        actionGroupId: actionGroup.id
      }
      // Add more actions if needed
    ]
    autoMitigate: true
  }
}

output alertId string = alert.id
