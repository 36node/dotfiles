#!/bin/sh
#
# DevOps 相关软件设置

alias k=kubecolor

# kr namespace deployment
function kr() {
  namespace=$1
  deployment=$2

  kubectl -n ${namespace} patch deployment ${deployment} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%Y%m%d%H%M)\"}}}}}"
}

# list all pods' limits and requests for all namespaces
function k-limits() {
  res=$(kubectl get pod --all-namespaces --sort-by='.metadata.name' -o json | jq -r '[.items[] | {pod_name: .metadata.name, containers: .spec.containers[] | [ {container_name: .name, memory_requested: .resources.requests.memory, cpu_requested: .resources.requests.cpu} ] }]')
  for item in $res
  do
    echo $item
    # echo $item | jq -r '.[] | .pod_name, .container_name, .cpu_requested, .memory_requested'
  done
}
