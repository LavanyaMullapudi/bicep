param location string = 'Global'
param existingActionGroupName string = 'qademo-cd-rx-actiongroup'
param storageaccountname string = 'sriyanshitest'

resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing= {
  name: 'storageaccountname'
}


resource StorageAccountCapacityAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'StorageAccount-Highcapacity-Alert'
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
            threshold: 4398046511104
            name: 'Metric1'
            metricNamespace: 'microsoft.storage/storageaccounts'
            metricName: 'UsedCapacity'
            operator: 'GreaterThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Fires when Storageaccount Capacity consumed 4.5TB'
    enabled: true
    evaluationFrequency: 'PT15M'
    scopes: [
      storageaccount.id 
   ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Storage/storageAccounts'
    windowSize: 'PT1H'
  }
}

// Alert for StorageAccount Availability
resource StorageAccountAvaialbilityAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'StorageAccount-Availability-Alert'
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
            threshold: 98
            name: 'Metric1'
            metricNamespace: 'microsoft.storage/storageaccounts'
            metricName: 'Availability'
            operator: 'LessThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: 'Fires when storage account availability threshold is below 98%'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      storageaccount.id ]
    severity: 0
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Storage/storageAccounts'
    windowSize: 'PT5M'
  }
}



