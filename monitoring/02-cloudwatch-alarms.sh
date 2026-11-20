#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${EKS_CLUSTER_NAME:-seguidores-eks-cluster}"
NAMESPACE="seguidores-prod"
SERVICE="seguidores-svc"
REGION="${AWS_REGION:-us-east-1}"

echo "Creando Metric Filter para errores HTTP 5xx y excepciones en CloudWatch Logs..."
aws logs put-metric-filter \
  --region "$REGION" \
  --log-group-name "/aws/containerinsights/${CLUSTER_NAME}/application" \
  --filter-name "${SERVICE}-http-5xx-errors" \
  --filter-pattern "?ERROR ?\"status\":500 ?\"Exception\"" \
  --metric-transformations \
      metricName="SeguidoresErrorCount",metricNamespace="SeguidoresApp/Observability",metricValue="1",defaultValue=0

echo "1. Alarma de Disponibilidad: Réplicas activas < 2"
aws cloudwatch put-metric-alarm \
  --region "$REGION" \
  --alarm-name "${SERVICE}-low-availability" \
  --alarm-description "Alerta crítica: menos de 2 pods running para seguidores-svc" \
  --metric-name pod_number_of_running_containers \
  --namespace ContainerInsights \
  --statistic Minimum \
  --period 60 \
  --evaluation-periods 2 \
  --threshold 2 \
  --comparison-operator LessThanThreshold \
  --dimensions Name=ClusterName,Value="$CLUSTER_NAME" Name=Namespace,Value="$NAMESPACE" Name=PodName,Value="$SERVICE" \
  --treat-missing-data breaching

echo "2. Alarma de Saturación de CPU (> 80% del límite)"
aws cloudwatch put-metric-alarm \
  --region "$REGION" \
  --alarm-name "${SERVICE}-high-cpu" \
  --alarm-description "Uso de CPU superior al 80% durante 3 minutos" \
  --metric-name pod_cpu_utilization_over_pod_limit \
  --namespace ContainerInsights \
  --statistic Average \
  --period 60 \
  --evaluation-periods 3 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=ClusterName,Value="$CLUSTER_NAME" Name=Namespace,Value="$NAMESPACE" Name=PodName,Value="$SERVICE"

echo "3. Alarma de Saturación de Memoria (> 85% del límite de 512Mi)"
aws cloudwatch put-metric-alarm \
  --region "$REGION" \
  --alarm-name "${SERVICE}-high-memory" \
  --alarm-description "Riesgo de OOMKilled: memoria superior al 85%" \
  --metric-name pod_memory_utilization_over_pod_limit \
  --namespace ContainerInsights \
  --statistic Average \
  --period 60 \
  --evaluation-periods 3 \
  --threshold 85 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=ClusterName,Value="$CLUSTER_NAME" Name=Namespace,Value="$NAMESPACE" Name=PodName,Value="$SERVICE"

echo "4. Alarma de Tasa de Errores de Aplicación (> 5 errores/min)"
aws cloudwatch put-metric-alarm \
  --region "$REGION" \
  --alarm-name "${SERVICE}-error-spike" \
  --alarm-description "Incremento anómalo de errores/excepciones en logs de seguidores-svc" \
  --metric-name SeguidoresErrorCount \
  --namespace SeguidoresApp/Observability \
  --statistic Sum \
  --period 60 \
  --evaluation-periods 1 \
  --threshold 5 \
  --comparison-operator GreaterThanThreshold \
  --treat-missing-data notBreaching