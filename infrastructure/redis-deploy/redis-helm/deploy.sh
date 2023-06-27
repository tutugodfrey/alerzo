#! /bin/bash

helm upgrade --install redis-develop . -n develop

helm upgrade --install redis-staging -f value-staging.yaml -n staging .

helm upgrade --install redis-production -f value-production.yaml -n production .

