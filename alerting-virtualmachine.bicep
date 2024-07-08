param location string = 'Global'
param vmName string = 'testvm'

resource ActionGroupName  'Microsoft.Insights/actionGroups@2021-09-01' existing = {
  name: existingActionGroupName
  // scope: resourceGroup(AgRgName)
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' existing = {
  name: vmName
}


//Alert for CPU percentage greater than 80%
resource vmmetricCPUAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'vm-highcpu-alert'
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
            threshold: 10
            name: 'Metric1'
            metricNamespace: 'Microsoft.Compute/virtualMachines'
            metricName: 'Percentage CPU'
            operator: 'GreaterThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'Fires when CPU utilization is greater than 80%'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      VirtualMachine.id

    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    windowSize: 'PT1M'
  }
}

//Alert for Consumed Data Disk over 90%
resource vmmetricDataDiskAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'vm-highdatadisk-alert'
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
            threshold: 90
            name: 'Metric1'
            metricNamespace: 'Microsoft.Compute/virtualMachines'
            metricName: 'Data Disk IOPS Consumed Percentage'
            operator: 'GreaterThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'Fires when Data Disk utilization is greater than 90%'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      VirtualMachine.id

    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    windowSize: 'PT1M'
  }
}

//Alert for Available Memory is 2GB
resource vmmetricAvailableMemory 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'vm-lowmemory-alert'
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
            threshold: 2000
            name: 'Metric1'
            metricNamespace: 'Microsoft.Compute/virtualMachines'
            metricName: 'Available Memory Bytes'
            operator: 'LessThan'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'Fires when Data Disk utilization is greater than 90%'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      VirtualMachine.id

    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    windowSize: 'PT1M'
  }
}

//Alert for VM Availability
resource vmmetricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'vm-Avalable-alert'
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
                    timeAggregation: 'Average'
                    name: 'Metric1'
                    metricNamespace: 'microsoft.compute/virtualmachines'
                    metricName: 'VmAvailabilityMetric'
                    operator: 'LessThan'
                    threshold: 1
                    criterionType: 'StaticThresholdCriterion'
                    
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    description: 'Fires when No VMs send Heartbeat in past 5 minutes'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      VirtualMachine.id

    ]
    severity: 2
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    windowSize: 'PT1M'
  }
}
