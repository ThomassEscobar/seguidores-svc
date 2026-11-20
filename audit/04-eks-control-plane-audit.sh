#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${EKS_CLUSTER_NAME:-seguidores-eks-cluster}"
REGION="${AWS_REGION:-us-east-1}"

echo "Habilitando logs de auditoría del Control Plane de EKS (api, audit, authenticator) hacia CloudWatch..."
aws eks update-cluster-config \
  --region "$REGION" \
  --name "$CLUSTER_NAME" \
  --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'