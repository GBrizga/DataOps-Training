targetScope = 'resourceGroup'

// Parameters
@description('Azure region for all resources')
param location string = resourceGroup().location

@description('Project name to prefix all resources')
param projectName string = 'dataops'

@description('Tags to apply to all resources')
param tags object = {
    project: projectName
    managedBy: 'bicep'
}

// Variables
var storageAccountName = replace('st${projectName}','-','')
var databricksWorkspaceName = 'dbw-${projectName}'
var dataFactoryName = 'adf-${projectName}'
var keyVaultName = 'kv-${projectName}'
var logAnalyticsName = 'log-${projectName}'

// Modules

// Storage Account (ADLS Gen2)
module storage 'modules/storage.bicep' = {
    name: 'deploy-storage'
    params: {
        storageAccountName: storageAccountName
        location: location
        tags: tags
    }
}

// Azure Databricks Workspace
module databricks 'modules/databricks.bicep' = {
    name: 'deploy-databricks'
    params: {
        workspaceName: databricksWorkspaceName
        location: location
        tags: tags
        pricingTier: 'standard'
    }
}

// Azure Data Factory
module dataFactory 'modules/datafactory.bicep' = {
    name: 'deploy-datafactory'
    params: {
        dataFactoryName: dataFactoryName
        location: location
        tags: tags
    }
}

// Azure Key Vault
module keyVault 'modules/keyvault.bicep' = {
    name: 'deploy-keyvault'
    params: {
        keyVaultName: keyVaultName
        location: location
        tags: tags
        adfPrincipalId: dataFactory.outputs.dataFactoryPrincipalId
    }
}

// Azure Log Analytics
module logAnalytics 'modules/loganalytics.bicep' = {
    name: 'deploy-loganalytics'
    params: {
        logAnalyticsName: logAnalyticsName
        location: location
        tags: tags
        dataFactoryName: dataFactoryName
        databricksWorkspaceName: databricksWorkspaceName
    }
}

// Outputs
output storageAccountName string = storage.outputs.storageAccountName
output storageAccountDfsEndpoint string = storage.outputs.primaryDfsEndpoint
output databricksWorkspaceUrl string = databricks.outputs.workspaceUrl
output dataFactoryName string = dataFactory.outputs.dataFactoryName
output keyVaultName string = keyVault.outputs.keyVaultName
output logAnalyticsName string = logAnalytics.outputs.logAnalyticsName


