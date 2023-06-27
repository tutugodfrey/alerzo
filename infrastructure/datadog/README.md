# DATADOG

```bash
kubectl -n datadog create secret generic datadog-secret --from-literal api-key=cd18e44a07da5fa23e9c8782aef17e73 --from-literal app-key=8453c35f0db41c9cf25288026e33665cc26be95a 
```

```bash
kubectl create namespace datadog
helm repo add datadog https://helm.datadoghq.com
```

Install the Datadog Operator in kubernetes

```bash
helm upgrade --install datadog-operator datadog/datadog-operator --namespace datadog
```

Create datadog secret to use with datadog agent

```bash
kubectl -n datadog create secret generic datadog-secret --from-literal api-key=038cc2c05aa3b1fdc1f431e14da7925a --from-literal app-key=8453c35f0db41c9cf25288026e33665cc26be95a
```

Deploy the datadog agent

```bash
kubectl apply -f datadog.yaml -n datadog
```

Installation with helm

```bash
helm upgrade --install datadog-agent -f values.yaml  --set datadog.apiKey=038cc2c05aa3b1fdc1f431e14da7925a --set datadog.appKey=8453c35f0db41c9cf25288026e33665cc26be95a --set datadog.clusterName=alerzopay --set datadog.site=datadoghq.eu --set clusterAgent.replicas=2 --set clusterAgent.createPodDisruptionBudget=true datadog/datadog --set targetSystem=linux -n datadog
```