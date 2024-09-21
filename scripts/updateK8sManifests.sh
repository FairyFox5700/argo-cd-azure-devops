#!/bin/bash

sed -i 's/\r$//' "$0"  # Only if this line is added at the start of the script

# Fail immediately on any error
set -x

# Retrieve sensitive information from environment variables
REPO_URL="https://${AZURE_DEVOPS_TOKEN}@dev.azure.com/${AZURE_DEVOPS_ORG}/voting-app/_git/voting-app"

ACR_REGISTRY_NAME="$ACR_REGISTRY_NAME"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Make changes to the Kubernetes manifest file(s)
# $1 is the environment (e.g., dev or prod)
# $2 is the app name, and $3 is the image tag
sed -i "s|image:.*|image: ${ACR_REGISTRY_NAME}/$2:$3|g" k8s-specifications/$1-deployment.yaml

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo
