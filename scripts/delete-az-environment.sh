#!/bin/bash -e

# constants
_BLUE='\033[1;34m'
_RED='\033[1;31m'
_NC='\033[0m'

_FORMAT="$0 resourceGroupName [--deleterg]"

_BASENAME=aibBuiUserId

# arguments check
if (( $# < 1 )); then
    echo -e "${_RED}Missing arguments.${_NC}\nUse this format:\n\t${_BLUE}$_FORMAT${_NC}"
    exit 1
fi

imageResourceGroup=$1

assignments=$(az role assignment list -g $imageResourceGroup)

if [[ $assignments != '[]' ]]; then
    echo "Deleting role assignments in rg $imageResourceGroup"
    az role assignment delete -g $imageResourceGroup
else
    echo "No role assignments to delete. Skipping."
fi

echo "Deleting role definitions assigned to this rg $imageResourceGroup"

az role definition list --query "[*].{scopes: assignableScopes, roleName: roleName} | [?scopes[?ends_with(@,'/resourceGroups/$imageResourceGroup')] ].roleName" | xargs -I{} az role definition delete -g $imageResourceGroup --name '{}'

echo "Deleting user identities in $imageResourceGroup"
az identity list -g $imageResourceGroup --query "[?starts_with(name,'$_BASENAME') ].id" -o tsv | xargs -I{} az identity delete -g $imageResourceGroup --ids {}

if [[ $2 == '--deleterg' ]]; then
    echo "Deleting $imageResourceGroup"
    az group delete -n $imageResourceGroup -y
fi