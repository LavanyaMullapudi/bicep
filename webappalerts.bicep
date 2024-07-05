param resourceGroupName string = 'acr-app-rg'
param actionGroupName string = 'dev-rhythmx'
param logAnalyticsWorkspaceId string = '1d5c322a-f894-4c3d-bb61-1ff5d54ea0f0'
param emailAddress string = 'sumanth.gurram@genzeon.com'
//targetScope = 'subscription'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: resourceGroup().location
  properties: {
    groupShortName: 'actiongroup'
    actions: [
      {
        actionGroupId: resourceId('Microsoft.ActionGroup/actionGroups', actionGroupName)
        webhookProperties: {}
        logicAppProperties: {}
      }
    ]
  }
}

var webAppNames = listWebAppNames(resourceGroupName)

//var webApps = [
 // for (webAppName in webAppNames) {
 //   name: webAppName
//}
// ]

// resource webApps array = [
//  for (webAppName in listWebAppNames(resourceGroupName)) {
//    name: webAppName
//  }
// ]

resource monitorAlertsCpu array = [
  for (webApp in webAppNames) {
    name: '${webApp.name}-cpu-alert'
    scope: resourceId('Microsoft.Web/sites', webApp.name)
    details: {
      actionGroupId: actionGroup.id
      logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceId
    }
    properties: {
      description: 'Alert for high CPU usage on ${webApp.name}'
      severity: 3 // 3 for critical
      enabled: true
      evaluationFrequency: 'PT5M' // 5 minutes
      windowSize: 'PT5M' // 5 minutes
      criteria: {
        allOf: [
          {
            metricName: 'CpuPercentage'
            operator: 'GreaterThan'
            threshold: 80
            timeAggregation: 'Average'
          }
        ]
      }
      actions: [
        {
          actionGroupId: actionGroup.id
        }
      ]
    }
  }
]

resource monitorAlertsMemory array = [
  for (webApp in webAppNames) {
    name: '${webApp.name}-memory-alert'
    scope: resourceId('Microsoft.Web/sites', webApp.name)
    details: {
      actionGroupId: actionGroup.id
      logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceId
    }
    properties: {
      description: 'Alert for high memory usage on ${webApp.name}'
      severity: 3 // 3 for critical
      enabled: true
      evaluationFrequency: 'PT5M' // 5 minutes
      windowSize: 'PT5M' // 5 minutes
      criteria: {
        allOf: [
          {
            metricName: 'MemoryPercentage'
            operator: 'GreaterThan'
            threshold: 70
            timeAggregation: 'Average'
          }
        ]
      }
      actions: [
        {
          actionGroupId: actionGroup.id
        }
      ]
    }
  }
]

output actionGroupId string = actionGroup.id
output monitorAlertsCpuIds array = [for (alert in monitorAlertsCpu) { alert.id }]
output monitorAlertsMemoryIds array = [for (alert in monitorAlertsMemory) { alert.id }]

// Function to retrieve list of web app names in the resource group
function listWebAppNames(resourceGroupName: string): array {
  var webApps = resources('Microsoft.Web/sites', resourceGroupName)
  return [
    for (webApp in webApps) {
      webApp.name
    }
  ]
}

