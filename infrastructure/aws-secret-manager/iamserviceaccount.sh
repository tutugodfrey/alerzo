#! /bin/bash

if [ -z $AWS_PROFILE ]; then
  export AWS_PROFILE=github-action
fi

eksctl create iamserviceaccount \
  --cluster=alerzopay \
  --namespace=default \
  --name=aws-secret-manager-controller \
  --role-name "AmazonEKSSEcretManagerRole" \
  --attach-policy-arn=arn:aws:iam::539850000317:policy/ekssecretmanager \
  --approve
