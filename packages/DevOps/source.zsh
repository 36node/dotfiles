#!/bin/sh
#
# DevOps 相关软件设置

alias k=kubectl

# kr namespace deployment
function kr() {
  namespace=$1
  deployment=$2

  kubectl -n ${namespace} patch deployment ${deployment} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%Y%m%d%H%M)\"}}}}}"
}
