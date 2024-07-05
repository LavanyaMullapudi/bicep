param resourceGroupName string = 'acr-app-rg'

var webAppList = resources('Microsoft.Web/sites', resourceGroupName);

output webAppNames array = [for (webApp in webAppList) : {
  name: webApp.name
}];
