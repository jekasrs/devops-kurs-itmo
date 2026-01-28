# devops-kurs-itmo
Курсовая работа "Разработка системы резервного копирования DevOps инфраструктуре"

## Требования
- kubectl (доступ к кластеру)
- helm
- velero CLI
- (опционально) mc (MinIO client) для измерения размера бакета

### Flow команд для реализации 
1. установить Velero
```
bash scripts/install-velero.sh
```

2. настроить пароль репозитория (Encryption)
```
bash scripts/set-repo-password.sh
```

3. задеплоить демо-приложение с PVC
```
bash scripts/deploy-demo.sh
```

4. сделать бэкап
```
bash scripts/backup.sh prod-manual-001
```

5. симулировать потерю данных (удаление namespace)
```
bash scripts/simulate-loss.sh
```

6. восстановить из бэкапа
```
bash scripts/restore.sh prod-restore-001 prod-manual-001
```

7. CronJob (по расписанию)
```
kubectl apply -f cronjobs/velero-cronjob-backup.yaml
kubectl -n velero get cronjob,job
velero backup get
```
