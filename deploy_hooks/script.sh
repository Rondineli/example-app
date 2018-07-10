#!/bin/bash

set -e

BASEDIR=$(dirname "$0")

if [ -z ${CIRCLE_TAG} ]; then
        VERSION_APP=${CIRCLE_SHA1}
        K8S_ENDPOINT=${K8S_ENDPOINT_STAG}
        K8S_TOKEN=${K8S_TOKEN_STAG}
        ECR_ENDPOINT=${ECR_ENDPOINT_STAG}

else
        VERSION_APP=${CIRCLE_TAG}
        K8S_ENDPOINT=${K8S_ENDPOINT_PROD}
        K8S_TOKEN=${K8S_TOKEN_PROD}
        ECR_ENDPOINT=${ECR_ENDPOINT_PROD}
fi

echo "installing kubectl ..."

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

### Kube Config role
sed -i "s/K8S_ENDPOINT_REPLACE/${K8S_ENDPOINT}/g" ./${BASEDIR}/kube_config
sed -i "s/TOKEN_REPLACE/${K8S_TOKEN}/g" ./${BASEDIR}/kube_config

### Deployment 
sed -i "s/VERSION_REPLACE/${VERSION_APP}/g" ./${BASEDIR}/deployment.yaml
sed -i "s/ECR_ENDPOINT_URL/${ECR_ENDPOINT}/g" ./${BASEDIR}/deployment.yaml

export KUBECONFIG=./${BASEDIR}/kube_config

kubectl apply -f ./${BASEDIR}/deployment.yaml
