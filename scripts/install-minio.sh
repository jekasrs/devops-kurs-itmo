#!/usr/bin/env bash
set -euo pipefail

echo "[1] Проверка зависимостей..."
command -v kubectl >/dev/null
command -v helm >/dev/null

echo "[2] Namespace minio..."
kubectl get ns minio >/dev/null 2>&1 || kubectl create namespace minio

echo "[3] Установка MinIO через Helm..."
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null

helm upgrade --install minio bitnami/minio \
  -n minio \
  -f manifests/minio/values.yaml

echo "[4] Проверка состояния..."
kubectl -n minio rollout status statefulset/minio --timeout=180s
kubectl -n minio get pods,svc

echo "MinIO установлен. Бакет 'velero' создан через defaultBuckets."
