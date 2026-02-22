@description('Name of the ADF')
param dataFactoryName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@description('Tags to apply to the resource')
param tags object = {}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

@description('The resource ID of the ADF')
output dataFactoryId string = dataFactory.id

@description('The name of the ADF')
output dataFactoryNameOutput string = dataFactory.name

@description('The principal ID of the ADF managed identity')
output dataFactoryPrincipalId string = dataFactory.identity.principalId
