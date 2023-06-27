# Commands to work with

```bash
aws cloudformation deploy --stack-name alerzopay-vpc --template-file vpc.yml --profile alerzo-tu
```

```bash
aws cloudformation deploy --stack-name alerzopay-nat-gateway --template-file nat-gateway.yml --profile alerzo-tu
```

```bash
eksctl create cluster -f cluster-setting.yaml
```

```bash
eksctl delete cluster --name test-cluster
```

```bash
aws cloudformation deploy --stack-name alerzopay-vpc-security-group --template-file vpc-security-groups.yaml
```

```bash
aws cloudformation deploy --stack-name alerzopay-eks-cluster-sg --template-file cluster-security-group.yaml --parameter-overrides EksClusterSG=REPLACE_WITH_EKS_CLUSTER_SG
```

```bash
aws cloudformation delete-stack --stack-name alerzopay-eks-cluster-sg
```