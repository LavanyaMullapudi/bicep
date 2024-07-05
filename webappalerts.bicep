param resourceGroupName string = 'acr-app-rg'
param actionGroupName string = 'dev-rhythmx'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: resourceGroup().location
  properties: {
    groupShortName: 'actiongroup'
    emailReceivers: []
    // Add other receivers as needed
  }
}

var webAppNames = [for (site in resources('Microsoft.Web/sites', resourceGroupName)) : {
  name: site.name
}]

resource monitorAlertsCpu 'Microsoft.Insights/metricAlerts@2020-08-01-preview' = [
  for (webAppName in webAppNames) {
    name: '${webAppName.name}-cpu-alert'
    location: resourceGroup().location
    scope: webAppName.id
    properties: {
      description: 'Alert for high CPU usage on ${webAppName.name}'
      severity: 3 // 3 for critical
      enabled: true
      evaluationFrequency: 'PT5M' // 5 minutes
      windowSize: 'PT5M' // 5 minutes
      criteria: {
        allOf: [
          {
            metricName: 'Percentage CPU'
            operator: 'GreaterThan'
            threshold: 80
            timeAggregation: 'Average'
          }
        ]
      }
      actions: [
        actionGroup.id
      ]
    }
  }
]

resource monitorAlertsMemory 'Microsoft.Insights/metricAlerts@2020-08-01-preview' = [
  for (webAppName in webAppNames) {
    name: '${webAppName.name}-memory-alert'
    location: resourceGroup().location
    scope: webAppName.id
    properties: {
      description: 'Alert for high memory usage on ${webAppName.name}'
      severity: 3 // 3 for critical
      enabled: true
      evaluationFrequency: 'PT5M' // 5 minutes
      windowSize: 'PT5M' // 5 minutes
      criteria: {
        allOf: [
          {
            metricName: 'Percentage Memory'
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
]

output actionGroupId string = actionGroup.id
output monitorAlertsCpuIds array = [for (alert in monitorAlertsCpu) { alert.id }]
output monitorAlertsMemoryIds array = [for (alert in monitorAlertsMemory) { alert.id }]
