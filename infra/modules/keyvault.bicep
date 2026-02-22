@description('Name of the Key Vault')
param keyVaultName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@description('Tags to apply to the resource')
param tags object = {}

@description('The tenant ID for the Key Vault')
param tenantId string = subscription().tenantId

@description('The principal ID of the ADF managed identity (needed to Get secrets)')
param adfPrincipalId string

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: true
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: adfPrincipalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

@description('The resource ID of the Key Vault')
output keyVaultId string = keyVault.id

@description('The URI of the Key Vault')
output keyVaultUri string = keyVault.properties.vaultUri

@description('The name of the Key Vault')
output keyVaultName string = keyVault.name
