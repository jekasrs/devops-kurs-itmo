#!/usr/bin/env bash
set -euo pipefail

command -v kubectl >/dev/null

echo "Удаление namespace prod (симуляция потери данных)..."
kubectl delete namespace prod --wait=true || true

echo "Проверка:"
kubectl get ns | grep -q "^prod" && echo "prod ещё существует" || echo "prod namespace deleted"
