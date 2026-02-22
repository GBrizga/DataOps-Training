@description('Name of the Databricks Workspace')
param workspaceName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@description('Tags to apply to the resource')
param tags object = {}

@description('Pricing tier of Databricks Workspace')
@allowed(['standard'])
param pricingTier string = 'standard'

@description('The managed resource group name for Databricks')
param managedResourceGroupName string = 'databricks-rg-${workspaceName}'

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2024-05-01' = {
  name: workspaceName
  location: location
  tags: tags
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
    parameters: {
      enableNoPublicIp: {
        value: false
      }
    }
  }
}

@description('The resource ID of the Databricks Workspace')
output workspaceId string = databricksWorkspace.id

@description('URL of the Databricks Workspace')
output workspaceUrl string = databricksWorkspace.properties.workspaceUrl
