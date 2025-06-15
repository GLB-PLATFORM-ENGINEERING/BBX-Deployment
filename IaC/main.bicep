param tenantId string

param funcAppName string

param funcAppAppRegClient string

param automationAccountName string

param appConfigName string

resource funcApp 'Microsoft.Web/sites@2024-11-01' existing = {
  name: funcAppName
}

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2024-06-01' existing = {
  name: appConfigName
}

resource funcAppConfig 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: funcApp
  name: 'authsettingsV2'
  properties: {
    globalValidation:{
      requireAuthentication:true
      unauthenticatedClientAction:'RedirectToLoginPage'
      redirectToProvider:'azureActiveDirectory'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled:true
        isAutoProvisioned:true
        login:{
          disableWWWAuthenticate:false
          loginParameters:[]
        }
        registration:{
          clientId:funcAppAppRegClient
          clientSecretSettingName:'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
          openIdIssuer:'https://sts.windows.net/${tenantId}/v2.0'
        }
        validation:{
          allowedAudiences:['api://${funcAppAppRegClient}']
          defaultAuthorizationPolicy:{
            allowedApplications:[funcAppAppRegClient]
          }
        }
      }
    }
    login:{
      tokenStore:{
        enabled:true
      }
    }
  }
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccountName
  location: 'westeurope'
  identity: {type:'SystemAssigned'}
  properties:{
    sku: {name: 'Free'}
    encryption:{keySource:'Microsoft.Automation'}
    publicNetworkAccess: true
  }
}

resource automationAccounts_AppConfig_var 'Microsoft.Automation/automationAccounts/variables@2024-10-23' = {
  parent: automationAccount
  name: 'AppConfigName'
  properties: {
    isEncrypted: false
    value: appConfigName
  }
}

resource aasystemAssignedIdentityAppConfig 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('App configuration data owner', 'Tenant', automationAccountName, appConfigName)
  scope: appConfig
  properties: {
    principalId:automationAccount.identity.principalId
    principalType:'ServicePrincipal'
    roleDefinitionId:subscriptionResourceId('Microsoft.Authorization/roleDefintions', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b')
  }
}

