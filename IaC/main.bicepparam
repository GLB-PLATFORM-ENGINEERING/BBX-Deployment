using 'main.bicep'

var tenant = readEnvironmentVariable('TenantId')
var faName = readEnvironmentVariable('functionAppName')
var faAppRegClient = readEnvironmentVariable('AzFaAppRegClient')
var AutomationAccountName = readEnvironmentVariable('AutomationAccountname')
var AppConfigName = readEnvironmentVariable('AppConfigName')

param tenantId = tenant
param funcAppName = faName
param funcAppAppRegClient = faAppRegClient
param automationAccountName = AutomationAccountName
param appConfigName = AppConfigName
