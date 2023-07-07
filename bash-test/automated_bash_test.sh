#!/bin/bash
set -exuo pipefail

# change directory to root module
cd ../

# create the resources 
terraform init
terraform apply -auto-approve

# wait while instance boots up
sleep 60

# query the output, extract ip and make request
# curl: -m, --max-time <seconds> Maximum time allowed for the transfer
terraform output -json |\
jq -r '.ip_addr.value' |\
xargs -I {} curl http://{}:8080 -m 10

# cleanup because resources at this point
terraform destroy -auto-approve
