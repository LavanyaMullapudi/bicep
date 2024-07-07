
param resourceGroupName string = 'acr-app-rg'
param appServiceName string = 'test-webapp-test'
param actionGroupName string = 'New-ActionGroup'
param location string = 'Global'

resource supportTeamActionGroup 'Microsoft.Insights/actionGroups@2021-09-01' = {
  name: actionGroupName
  location: location

  properties: {
    groupShortName: actionGroupName
    enabled: true
    actions: []
  }
}


resource appServiceResource 'Microsoft.Web/sites@2021-02-01' existing = {
  name: appServiceName
 // location: location
}

resource alertResource 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: 'HighCPUPercentageAlert'
  location: location
  properties: {
    description: 'Alert on CPU greater than 80% for Azure Web App'
    severity: 3
    enabled: true
    scopes: [
      appServiceResource.id
    ]
    criteria: {
      allOf: [
        {
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
          dimensions: []
        }
      ]
    }
    actions: [
      {
        actionGroupId: supportTeamActionGroup.id
      }
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
  }
}

output alertResourceId string = supportTeamActionGroup.id
