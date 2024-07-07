param location string = 'Global'
param AgLawRg string = 'acr-app-rg'
param ApplicationInsightsName string = 'test-webapp-appins'
// param loganalyticsworkspaceName string = 'acr-app-rg'
// param newActionGroupName string = 'Test-action-group'
param environmentType string = 'qademo'
param emailinternal string = 'lavanya.mullapudi@rhythmx.ai'

var environmentConfigurationMap = {
  qademo: {
    shortprefix: '${environmentType}-cd-rx'
    prefix: '${environmentType}-cd-rx'
    emaillist: emailinternal
    }
  
 stagedemo: {
    shortprefix: '${environmentType}-cd-rx'
    prefix: '${environmentType}-cd-rx'
    emaillist: emailinternal
    }
}

resource ActionGroupName 'Microsoft.Insights/actionGroups@2021-09-01' = {
  name: '${environmentConfigurationMap[environmentType].prefix}-actiongroup'
  location: 'Global'
  properties: {
    enabled: true
    groupShortName: '${environmentConfigurationMap[environmentType].shortprefix}-ag'
    emailReceivers: environmentConfigurationMap[environmentType].emaillist
  }
}

resource ApplicationInsights 'Microsoft.Insights/components@2015-05-01' existing = {
  name: ApplicationInsightsName
  scope: resourceGroup(AgRgName)
}

/*
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: loganalyticsworkspaceName
  scope: resourceGroup(AgLawRg)
}
*/
resource Appservice 'Microsoft.Web/sites@2015-08-01' existing = {
  name: appserviceName 
}

resource AppServiceLowMemoryAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${appserviceName}-LowMemory-Alert'
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
            threshold: 1600000000
            name: 'Metric1'
            metricNamespace: 'microsoft.insights/components'
            metricName: 'performanceCounters/memoryAvailableBytes'
            operator: 'LessThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
					
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Fires when Available Memory is GreaterThan 1.5GB'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      ApplicationInsights.id
    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'microsoft.insights/components'
    windowSize: 'PT5M'
  }
}

resource AppServiceHighCPUAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${appserviceName}-HighCPU-Alert'
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
            threshold: 80
            name: 'Metric1'
            metricNamespace: 'microsoft.insights/components'
            // metricName: 'performanceCounters/memoryAvailableBytes'
            metricName: 'performanceCounters/processor utilization'
            operator: 'GreaterThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
					
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Fires when Available CPU is GreaterThan 80 percent'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      ApplicationInsights.id
    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'microsoft.insights/components'
    windowSize: 'PT5M'
  }
}

resource AppService5xx 'microsoft.insights/metricalerts@2018-03-01' = {
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
           threshold: 5
           name: 'Metric1'
           metricNamespace: 'Microsoft.Web/sites'
           metricName: 'Http5xx'
           operator: 'GreaterThan'
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
