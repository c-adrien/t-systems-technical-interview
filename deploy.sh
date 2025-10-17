#!/bin/bash

# Variables
# -------------------------------------


# Requires environment variables:
# AZURE_CLIENT_ID
# AZURE_CLIENT_SECRET
# AZURE_TENANT_ID
# OPENROUTER_API_KEY

if [ -z "$AZURE_CLIENT_ID" ] || [ -z "$AZURE_CLIENT_SECRET" ] || [ -z "$AZURE_TENANT_ID" ] || [ -z "$OPENROUTER_API_KEY" ]; then
  echo "Please set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID, and OPENROUTER_API_KEY environment variables."
  exit 1
fi


RESOURCE_GROUP="technical_interview"
LOCATION="eastus"
WEBAPP_NAME="technical-interview-php-chatbot"
RUNTIME="PHP:8.4"

GITHUB_REPO="https://github.com/c-adrien/t-systems-technical-interview.git"
GITHUB_BRANCH="chatbot"

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


# Configure App Settings - for API key
az webapp config appsettings set \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP \
    --settings \
        OPENROUTER_API_KEY="$OPENROUTER_API_KEY"