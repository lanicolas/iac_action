#!/bin/bash -e

###############################################################################
# This script must be run with admin rights, it creates the service principal
# that should be used as a secret in GitHub to run the actions
###############################################################################

# constants
_BLUE='\033[1;34m'
_RED='\033[1;31m'
_NC='\033[0m'

_FORMAT="$0 uniqueName"

_BASENAME=aibBuiUserId

# arguments check
if (( $# < 1 )); then
    echo -e "${_RED}Missing arguments.${_NC}\nUse this format:\n\t${_BLUE}$_FORMAT${_NC}"
    exit 1
fi

subscriptionID=$(az account show --query id -o tsv)
uniqueName=$1

adName="github-$uniqueName"


spId=$(az ad sp list --display-name "$adName" --query [].objectId -o tsv)
if [[ -n "$spId" ]]
then
    az ad sp delete --id $spId
fi

az ad sp create-for-rbac --name $adName --role contributor --scopes /subscriptions/$subscriptionID --sdk-auth >> ".$uniqueName.cred"

echo -e "Credentials created. To see them, run the command:\n\tcat .$uniqueName.cred "

