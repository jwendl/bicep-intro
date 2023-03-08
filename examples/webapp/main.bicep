param workload string
param environment string

@minLength(3)
param location string = resourceGroup().location

var resourceSuffix = '${workload}-${environment}-${location}'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'umi-${resourceSuffix}-001'
  location: location
}

resource servicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-${resourceSuffix}-001'
  location: location
  sku: {
    name: 'S1'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webapp-${resourceSuffix}-001'
  location: location

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }

  properties: {
    serverFarmId: servicePlan.id
  }
}
