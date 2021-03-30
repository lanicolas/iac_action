#!/bin/bash -e

###############################################################################
# This script must be run with admin rights, it creates the resource group and 
# the Service Principal for running the environment preparation
###############################################################################

# constants
_BLUE='\033[1;34m'
_RED='\033[1;31m'
_NC='\033[0m'

_FORMAT="$0 resourceGroupName"

_BASENAME=aibBuiUserId

# arguments check
if (( $# < 1 )); then
    echo -e "${_RED}Missing arguments.${_NC}\nUse this format:\n\t${_BLUE}$_FORMAT${_NC}"
    exit 1
fi

subscriptionID=$(az account show --query id -o tsv)
resourceGroupName=$1

adName="github-$resourceGroupName"


spId=$(az ad sp list --display-name "$adName" --query [].objectId -o tsv)
if [[ -n "$spId" ]]
then
    az ad sp delete --id $spId
fi

credentials=$(az ad sp create-for-rbac --name $adName --role contributor --scopes /subscriptions/$subscriptionID/resourceGroups/$resourceGroupName --sdk-auth)

echo -e "Use this credentials in GitHub:\n$credentials"

