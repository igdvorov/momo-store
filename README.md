## Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./... 
```

## Helm Chart

```bash
helm upgrade --install momo-store momo-store-chart 
```

##### Приложение доступно по адрессу https://mymomostore.space

##### Мониторинг доступен по адрессу https://grafana.mymomostore.space

##### Креды для пользователя viewer с правами на просмотр:

```bash
username: viewer
password: viewer
```

# Структура репозитория

```bash
├── README.md
├── backend - Backend sources dir
├── frontend - Frontend sources dir
├── k8s-terraform - K8s cluster terraform
├── kubernetes - K8s manifests
├── momo-store-chart - Application Helm Chart
└── monitoring - Grafana & Prometheus Charts
```
# Инфраструктура

##### Managed kubernetes cluster
- 2 cpu, 4 ram. Кластер описан в Terraform.

##### S3 bucket:
- Хранения изображений
- Terraform state

##### Для приложения был куплен домен mymomostore.space. В YCloud были настроенны Cloud DNS

<img width="400" alt="dashboard" src="https://storage.yandexcloud.net/dvorov-ivan/domain.png">

# В качестве мониторинга:
##### Grafana - Дашборды с метриками

<img width="900" alt="dashboard" src="https://storage.yandexcloud.net/dvorov-ivan/momo-dashboard.png">

##### Loki Promtail для просмотра и хранения логов

<img width="900" alt="logs" src="https://storage.yandexcloud.net/dvorov-ivan/momo-logs.png">

# Сборка образов и артефактов происходит в module-pipline, реализован ручной деплой по "кнопке" в GitLab.

<img width="700" alt="deploy" src="https://storage.yandexcloud.net/dvorov-ivan/deploy.png">

# Helm чарты приложения хранятся в репозитории Nexus
https://nexus.praktikum-services.ru/repository/momo-store-helm-dvorov-ivan-04

# Версия приложения и Helm чартов задана в формате 
```bash
VERSION: 1.0.${CI_PIPELINE_ID}:
```
