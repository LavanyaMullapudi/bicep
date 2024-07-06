param location "eastus"
param AgLawRg "acr-app-rg"
param ApplicationInsightsName "acr-app-rg"
param actiongroupname string
param loganalyticsworkspaceName "acr-app-rg"
param newActionGroupName "test-action"

resource supportTeamActionGroup 'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: newActionGroupName
  location: location
  tags: {
    displayName: newActionGroupName
  }
  properties: {
    groupShortName: newActionGroupName
    enabled: true
    actions: []
  }
}

resource ApplicationInsights 'Microsoft.Insights/components@2015-05-01' existing = {
  name: ApplicationInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: loganalyticsworkspaceName
  scope: resourceGroup(AgLawRg)
}

resource diagnosticLogs 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  name: ApplicationInsights.name
 scope: ApplicationInsights
  properties: {
    workspaceId: logAnalyticsWorkspace.id
     logs: [
            {
                category: null
                categoryGroup: 'allLogs'
                enabled: true
               // retentionPolicy: {
                //days: 90
                //enabled: false
               // }
            }
        ]
		metrics: [		  
            {
                enabled: true
               // retentionPolicy: {
               //     days: 90
                //    enabled: true
              //  }
				category: 'AllMetrics'					   
            }
    ]
  }
}

resource AppServiceLowMemoryAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'Appservice-LowMemory-Alert'
  location: 'Global' 
  
  properties: {
    actions: [
      {
        actionGroupId: supportTeamActionGroup.id
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
  name: 'Appservice-HighCPU-Alert'
  location: 'Global' 
  
  properties: {
    actions: [
      {
        actionGroupId: supportTeamActionGroup.id
      }
    ]
    autoMitigate: true
    criteria: {
      allOf: [
        {
            threshold: 80
            name: 'Metric1'
            metricNamespace: 'microsoft.insights/components'
            metricName: 'performanceCounters/memoryAvailableBytes'
            operator: 'GreaterThan'
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
