@description('The name of the Log Analytics Workspace')
param logAnalyticsName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@description('Tags to apply to the resource')
param tags object = {}

@description('Name of the ADF for diagnostic settings')
param dataFactoryName string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Existing resources to link diagnostic settings
resource existingAdf 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

// Diagnostic settings for ADF
resource adfDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${dataFactoryName}-diagnostic'
  scope: existingAdf
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'ActivityRuns'
        enabled: true
      }
      {
        category: 'PipelineRuns'
        enabled: true
      }
      {
        category: 'TriggerRuns'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

@description('The resource ID of the Log Analytics Workspace')
output logAnalyticsId string = logAnalytics.id

@description('The name of the Log Analytics Workspace')
output logAnalyticsName string = logAnalytics.name
