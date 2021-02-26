#!/bin/bash

# AWS creds
AWS_ACCESS_KEY_ID=${1}
AWS_SECRET_ACCESS_KEY=${2}
AWS_DEFAULT_REGION=${3}
AWS_ORG_ID=${4}
AWS_EKS_CLUSTER_NAME=${5}

aws configure set region ${AWS_DEFAULT_REGION}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set role_arn "arn:aws:iam::${AWS_ORG_ID}:role/adminAssumeRole"
aws configure set source_profile default

echo ">>> AWS_EKS_CLUSTER_NAME=${AWS_EKS_CLUSTER_NAME}"
aws eks update-kubeconfig --role-arn "arn:aws:iam::${AWS_ORG_ID}:role/adminAssumeRole" --name="${AWS_EKS_CLUSTER_NAME}" --kubeconfig /tmp/kubeconfig
echo ">>>> kubeconfig created"
export KUBECONFIG=/tmp/kubeconfig
ls /tmp/kubeconfig

# GitHub creds
GITHUB_PAT=${6}
ORG=${7}
INFRA_REPO=${8}
PR_REF=${9}

git clone https://${GITHUB_PAT}@github.com/${ORG}/${INFRA_REPO}.git
cd infrastructure
git config --local user.name "GitHub Action"
git config --local user.email "action@github.com"

git remote set-url origin https://x-access-token:${GITHUB_PAT}@github.com/${ORG}/${INFRA_REPO}
git push origin --delete ${PR_REF}

REGEX="[a-zA-Z]+-[0-9]{1,5}"
if [[ ${PR_REF} =~ $REGEX ]]; then
    export NAMESPACE=$(echo ${BASH_REMATCH[0]} | tr '[:upper:]' '[:lower:]')
else
    echo ">>>> ${PR_REF} is not a feature branch, nothing to cleanup"
    exit 0
fi

if [[ $(kubectl -n argocd get application ${NAMESPACE}) ]]; then
    echo ">>>> Argo Application exist, Deleating now..."
    kubectl -n argocd delete application ${NAMESPACE}
else
    echo ">>>> Argo Application Does not exist, nothing to clean. OK!"
fi