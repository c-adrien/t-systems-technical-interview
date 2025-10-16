#!/bin/bash

# Variables
# -------------------------------------


# Requires environment variables:
# AZURE_CLIENT_ID
# AZURE_CLIENT_SECRET
# AZURE_TENANT_ID

if [ -z "$AZURE_CLIENT_ID" ] || [ -z "$AZURE_CLIENT_SECRET" ] || [ -z "$AZURE_TENANT_ID" ]; then
  echo "Please set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID environment variables."
  exit 1
fi


RESOURCE_GROUP="technical_interview"
LOCATION="eastus"
WEBAPP_NAME="technical-interview-php"
RUNTIME="PHP:8.4"

GITHUB_REPO="https://github.com/c-adrien/t-systems-technical-interview.git"
GITHUB_BRANCH="main"

# Commands
# -------------------------------------

# Azure Login
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# Create Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Web app service - PHP App
az webapp up --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP --location $LOCATION \
    --sku F1 \
    --os-type Linux --runtime "$RUNTIME"

# Web App configuration
az webapp deployment source config \
    --repo-url $GITHUB_REPO --branch $GITHUB_BRANCH --manual-integration \
    --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP
