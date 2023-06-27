#! /bin/bash

helm upgrade --install datadog-agent datadog/datadog \
  -f values.yaml  --set datadog.apiKey=038cc2c05aa3b1fdc1f431e14da7925a \
  --set datadog.appKey=8453c35f0db41c9cf25288026e33665cc26be95a \
  --set datadog.clusterName=alerzopay \
  --set datadog.site=datadoghq.eu \
  --set clusterAgent.replicas=2 \
  --set clusterAgent.createPodDisruptionBudget=true \
  --set targetSystem=linux -n datadog