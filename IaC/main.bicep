param tenantId string
param funcAppName string
param funcAppAppRegClient string

resource funcApp 'Microsoft.Web/sites@2024-11-01' existing = {
  name: funcAppName
}

resource funcAppConfig 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: funcApp
  name: 'authsettingsV2'
  properties: {
    globalValidation:{
      requireAuthentication:true
      unauthenticatedClientAction:'RedirectToLoginPage'
      redirectToProvider:'Microsoft'
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
            allowedPrincipals:{
              groups:[]
              identities:[]
            }
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

