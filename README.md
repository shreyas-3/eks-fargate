# eks fargate node/pod update
**Script to update fargate node/pod after eks cluster upgrade.**

Usage: upgrade_eks_fargate_node_pod.sh <latest kubernetes vesion> <eks namespace>
example: upgrade_eks_fargate_node_pod.sh v1.20.4 kube-system  
  This script will check if pod on latest or older faragte node. If pod is on older node restart deployment with rolling update to have zero downtime.
  In this case older node version is 1.19.6 and latest node version is 1.20.4
