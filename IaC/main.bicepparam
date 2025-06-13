using 'main.bicep'

var tenant = readEnvironmentVariable('TenantId')
var faName = readEnvironmentVariable('functionAppName')
var faAppRegClient = readEnvironmentVariable('AzFaAppRegClient')

param tenantId = tenant
param funcAppName = faName
param funcAppAppRegClient = faAppRegClient
