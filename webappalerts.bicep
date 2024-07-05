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
}];

resource monitorAlertsCpu 'Microsoft.Insights/metricAlerts@2020-08-01-preview' = {
  name: '${webAppNames[0].name}-cpu-alert' // Corrected to use webAppNames[0].name for the first web app name
  location: resourceGroup().location
  scope: webAppNames[0].id // Corrected to use webAppNames[0].id for the first web app id
  properties: {
    description: 'Alert for high CPU usage on ${webAppNames[0].name}'
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
};

resource monitorAlertsMemory 'Microsoft.Insights/metricAlerts@2020-08-01-preview' = {
  name: '${webAppNames[0].name}-memory-alert' // Corrected to use webAppNames[0].name for the first web app name
  location: resourceGroup().location
  scope: webAppNames[0].id // Corrected to use webAppNames[0].id for the first web app id
  properties: {
    description: 'Alert for high memory usage on ${webAppNames[0].name}' // Corrected to use webAppNames[0].name for the first web app name
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
};


output actionGroupId string = actionGroup.id
output monitorAlertsCpuIds array = [monitorAlertsCpu.id]
output monitorAlertsMemoryIds array = [monitorAlertsMemory.id]
