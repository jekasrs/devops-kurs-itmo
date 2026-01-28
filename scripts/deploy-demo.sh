#!/usr/bin/env bash
set -euo pipefail

command -v kubectl >/dev/null

echo "Применение prod-demo.yaml..."
kubectl apply -f prod-demo.yaml

echo "Ожидание готовности pod..."
kubectl -n prod rollout status deploy/demo-writer --timeout=180s

echo "Проверка ресурсов..."
kubectl -n prod get pods,pvc,cm
