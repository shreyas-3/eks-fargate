#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Please provide arguments"
    echo "Usage: $0 <latest kubernetes vesion> <eks namespace>"
    echo "Usage: upgrade_eks_fargate_node_pod.sh v1.20.4 kube-system"
    exit 1
fi

eks_namepsace=$2
latest_version=$1
echo "**********************************************************"
for pod in $(kubectl get pod -n $eks_namepsace -o wide | grep -v Completed | awk '{ print $1 }' | grep -v NAME);do

        faragte_node=$(kubectl get pod $pod -n $eks_namepsace -o wide | awk '{ print $7 }' | grep -v NODE)

        for dep in $(kubectl get deployment -n $eks_namepsace | awk '{ print $1 }' | grep -v NAME);do
                if [[ $pod =~ "$dep" ]]; then
                        eks_deployment=$dep
                fi
        done

        current_version=$(kubectl get node $faragte_node | awk '{ print $5 }' | grep -v VERSION)

        if [[ $current_version =~ "$latest_version" ]]; then
                echo "Pod $pod is already on latest node"
                echo "**********************************************************"
        else
                echo "Pod $pod is on OLD node, need deployment restart rollout"
                kubectl rollout restart deployment/$eks_deployment -n $eks_namepsace
                kubectl rollout status deployment/$eks_deployment -n $eks_namepsace
                echo "**********************************************************"
        fi
done
