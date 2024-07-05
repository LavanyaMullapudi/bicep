param resourceGroupName string = 'acr-app-rg'

resource webAppList 'Microsoft.Web/sites@2021-02-01' existing = {
  name: resourceGroupName
}

output webAppNames array = [for (webApp in webAppList) : {
  name: webApp.name
}];
