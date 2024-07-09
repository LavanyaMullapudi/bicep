param appserviceName string = 'test-webapp-test'
param appName string = 'ASP-acrapprg-bba3'
param existingActionGroupName string = 'qademo-cd-rx-actiongroup'
param location string = 'global'

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
resource AppserviceCPUAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
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
          metricNamespace: 'Microsoft.Web/serverfarms'
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

resource AppServiceMemory 'microsoft.insights/metricalerts@2018-03-01' = {
  name: '${appserviceName}-AppService5xx'
  location: 'Global'  
  properties: {
    actions: [
      {
        actionGroupId: ActionGroupName.id
      }
    ]
    autoMitigate: false
    criteria: {
      allOf: [
        {
           name: 'Metric1'
           metricNamespace: 'Microsoft.Web/sites'
           metricName: 'AverageMemoryWorkingSet'
           operator: 'GreaterThan'
           threshold: 3500
           timeAggregation: 'Average'
           criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'Fires when AppService HTTP response code is 5xx'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      Appservice.id
    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Web/sites'
    windowSize: 'PT5M'
  }
}

resource healthCheckAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${appserviceName}-HealthCheck-Alert'
  location: 'Global'
  properties: {
    description: 'Alert triggered when health check status indicates service degradation for Azure Web App'
    severity: 2
    enabled: true
    scopes: [
      Appservice.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          name: 'Metric1'
          metricName: 'HealthCheckStatus'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'LessThan' // Health check is often considered degraded when availability is less than 100%
          threshold: 100 // Example threshold (less than 100% availability)
          timeAggregation: 'Average'
          alertSensitivity: 'High'
          criterionType: 'DynamicThresholdCriterion' // Health check often uses dynamic thresholds based on historical data
         failingPeriods: {
            minFailingPeriodsToAlert: 2
            numberOfEvaluationPeriods: 5
          }
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

