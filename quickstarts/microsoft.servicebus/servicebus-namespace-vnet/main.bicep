@description('Name of the Service Bus namespace')
param serviceBusNamespaceName string

@description('Name of the Virtual Network Rule')
param vnetRuleName string

@description('Name of the Virtual Network Sub Net')
param subnetName string

@description('Location for Namespace')
param location string = resourceGroup().location

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Premium'
    tier: 'Premium'
  }
  properties: {}
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '{vnetRuleName}-vn'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/23'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: '10.0.0.0/23'
    serviceEndpoints: [
      {
        service: 'Microsoft.ServiceBus'
      }
    ]
  }
}

resource namespaceVirtualNetworkRule 'Microsoft.ServiceBus/namespaces/virtualnetworkrules@2018-01-01-preview' = {
  parent: serviceBusNamespace
  name: vnetRuleName
  properties: {
    virtualNetworkSubnetId: subnet.id
  }
}
