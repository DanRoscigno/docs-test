#!/bin/bash

# This script patches the Docusaurus docs/siteConfig.js (or docusaurus.config.js) to:
# - Remove any cname or url parameter
# - Set the baseUrl to /<repository_name>
#
# Takes the GitHub repository name as input and must be executed in the project root folder

REPO_NAME=$1

USER_NAME=$2

DOCUSAURUS_CONFIG=""
VERSION=0

if [ -f "docs/siteConfig.js" ]; then
    DOCUSAURUS_CONFIG="docs/siteConfig.js"
    VERSION=1
    echo "Found Docusaurus v1 docs config on $PWD/docs/siteConfig.js"
elif [ -f "docs/docusaurus.config.js" ]; then
    DOCUSAURUS_CONFIG="docs/docusaurus.config.js"
    VERSION=2
    echo "Found Docusaurus v2 docs config on $PWD/docs/docusaurus.config.js"
else
    echo "ERROR! Could not find Docusaurus configuration; check that either docs/docusaurus.config.js or docs/docusaurus.config.js exist."
    exit -1
fi

echo "Patching repo $REPO_NAME ..."

BASE_URL="'\/$REPO_NAME\/',"

URL="'\/https:\/\/${USER_NAME}.github.io\/$REPO_NAME',"

sed -i "s/baseUrl:.*/baseUrl: $BASE_URL/" $DOCUSAURUS_CONFIG

docusaurus.config.js
sed -i "s/url:.*/url: $URL/" $DOCUSAURUS_CONFIG

USER_NAME="'${USER_NAME}',"
sed -i "s/organizationName:.*/organizationName: $USER_NAME/" $DOCUSAURUS_CONFIG

# Remove CNAME settings
if [ "$VERSION" = "1" ]; then
    sed -i '/cname:/d' docs/siteConfig.js
else
    rm -rf docs/static/CNAME
fi

echo "Done! $PWD/$DOCUSAURUS_CONFIG updated!"
