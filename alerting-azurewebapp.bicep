param appserviceName string = 'test-webapp-test'
param appName string = 'ASP-acrapprg-bba3'
param existingActionGroupName string = 'qademo-cd-rx-actiongroup'


resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}
resource Appservice 'Microsoft.Web/sites@2015-08-01' existing = {
  name: appserviceName 
}
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appName
  //scope: resourceGroup(resourceGroupName)
}
resource cpuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${appserviceName}-HighCPU-Alert'
  location: 'Global'
  properties: {
    description: 'Alert triggered when CPU percentage exceeds 80% for Azure Web App'
    severity: 2
    enabled: true
    scopes: [
      appServicePlan.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          name: 'Metric1'
          metricName: 'CpuPercentage'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
  }
}
