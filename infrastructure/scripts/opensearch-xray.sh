 # - |
  #   # Install and configure gitlab runner
  #   helm repo add gitlab https://charts.gitlab.io
  #   helm fetch gitlab/gitlab-runner --untar
  #   if ! kubectl create namespace gitlab; then echo namespace gitlab already exist; fi
  #   if ! kubectl -n gitlab create secret generic s3access --from-literal=accesskey=${AWS_ACCESS_KEY_ID} --from-literal=secretkey=${AWS_SECRET_ACCESS_KEY}; then echo secret already exist; fi
  #   helm upgrade  --install  --namespace gitlab -f gitlab-runner-values.yaml gitlab-runner gitlab-runner

  # - |
  #   # Configure Amazon CloudWatch Container Insight
  #   kubectl create namespace amazon-cloudwatch || echo Namespace amazon-cloudwatch already exist
  #   STACK_NAME=$(eksctl get nodegroup --cluster ${CLUSTER_NAME} -o json | jq -r '.[].StackName' | tail -n 1)
  #   echo $STACK_NAME
  #   ROLE_NAME=$(aws cloudformation describe-stack-resources \
  #     --stack-name ${STACK_NAME} | jq -r '.StackResources[] | select(.ResourceType=="AWS::IAM::Role") | .PhysicalResourceId');
  #   echo $ROLE_NAME
  #   aws iam attach-role-policy --role-name $ROLE_NAME \
  #     --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy;

  #   # Checking What is attached 
  #   aws iam list-attached-role-policies --role-name $ROLE_NAME
  #   curl -s https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | \
  #     sed "s/{{cluster_name}}/${CLUSTER_NAME}/;s/{{region_name}}/${AWS_REGION}/" | \
  #     kubectl apply -f -

  # - |
  #   # Add service account for integration with OpenSearch (ElasticSearch)
  #   export FLUENT_BIT_NAMESPACE=logging
  #   export AWS_REGION=${AWS_DEFAULT_REGION}
  #   if ! aws iam get-policy --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${FLUENT_BIT_POLICY}; then
  #     sed -i "s/REPLACE_WITH_AWS_REGION/${AWS_REGION}/" monitoring/fluent-bit-policy.json
  #     sed -i "s/REPLACE_WITH_AWS_ACCOUNT_ID/${AWS_ACCOUNT_ID}/" monitoring/fluent-bit-policy.json
  #     sed -i "s/REPLACE_WITH_ES_DOMAIN_NAME/${ES_DOMAIN_NAME}/" monitoring/fluent-bit-policy.json
  #     aws iam create-policy --policy-name ${FLUENT_BIT_POLICY} --policy-document file://monitoring/fluent-bit-policy.json
  #   fi
  #   kubectl create namespace ${FLUENT_BIT_NAMESPACE} || echo Namespace ${FLUENT_BIT_NAMESPACE} already exist
  #   eksctl create iamserviceaccount \
  #     --name ${FLUENT_BIT_SA}  \
  #     --namespace ${FLUENT_BIT_NAMESPACE} \
  #     --cluster ${CLUSTER_NAME} \
  #     --attach-policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${FLUENT_BIT_POLICY} \
  #     --approve --override-existing-serviceaccounts
  #   kubectl -n ${FLUENT_BIT_NAMESPACE} get sa

  # - |
  #   # Configure X-ray for tracing
  #   if ! kubectl create namespace xray; then echo Namespace xray already exist; fi
  #   eksctl create iamserviceaccount \
  #     --name xray-daemon --namespace xray \
  #     --cluster ${CLUSTER_NAME} \
  #     --attach-policy-arn arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess \
  #     --approve --override-existing-serviceaccounts
  #   kubectl --namespace xray get sa
  #   kubectl --namespace xray label serviceaccount xray-daemon app=xray-daemon || echo Label already applied
  #   kubectl --namespace xray apply -f monitoring/xray-k8s-daemonset.yaml
