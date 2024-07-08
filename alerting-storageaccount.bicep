param location string = 'Global'
param existingActionGroupName string = ''

resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing= {
  name: '${storageaccountnameprefix}storage'
}

//Alert for storage account login failure exceeding 5 counts
resource storageaccountmetricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'storageaccount-loginfail-alert'
  location: location
  
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
            threshold: 5
            name: 'Metric1'
            metricNamespace: 'Microsoft.Storage/StorageAccounts'
            metricName: 'Transactions'
            dimensions: [
              {
                name: 'ResponseType'
                operator: 'Exclude'
                values: ['Success']
              }
              {
                name: 'ApiName'
                operator: 'Include'
                values: ['SftpConnect']
              }
            ]
            operator: 'GreaterThan'
            timeAggregation: 'Total'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'SFTP login failure count exceeds 5 in the last 5 min'
    enabled: true
    evaluationFrequency: 'PT1M'
    targetResourceType: 'Microsoft.Storage/StorageAccounts'
    scopes: [
      storageaccount.id

    ]
    severity: 3
    targetResourceRegion: location
    windowSize: 'PT1M'
  }
}

