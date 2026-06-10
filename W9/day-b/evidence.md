# Day B Evidence Checklist

Muc tieu cua evidence Day B la chung minh app co observability: expose metrics, co cau hinh OpenTelemetry Collector, co Prometheus query/alert rule va co Grafana dashboard.

## 1. File can mo cho mentor xem

Mo cac file nay trong VS Code hoac GitHub va chup man hinh:

- [ ] `app/app.py`: co route `/metrics` va metrics `http_requests_total`, `http_request_duration_seconds`.
- [ ] `day-b/otel/collector-config.yaml`: co receivers `otlp`, `prometheus`, exporter `logging`, pipelines `metrics/logs/traces`.
- [ ] `day-b/alert-rules/slo-burn-rate.yaml`: co alert `HighErrorBudgetBurnFast` va `HighErrorBudgetBurnSlow`.
- [ ] `day-b/dashboards/grafana-dashboard.json`: co 4 panel `Total Requests`, `Error Rate`, `Request Latency`, `App Health`.
- [ ] `day-b/README.md` va `day-b/notes.md`: giai thich Observability, OTel, Prometheus, Grafana, SLO/Burn Rate.

## 2. Validate file local truoc khi demo

Tu thu muc `E:\cloud\W9`, chay:

```powershell
cd E:\cloud\W9
py -m json.tool day-b\dashboards\grafana-dashboard.json
py -c "import pathlib,yaml; [list(yaml.safe_load_all(p.read_text(encoding='utf-8'))) for p in pathlib.Path('day-b').rglob('*.yaml')]; print('Day B YAML OK')"
```

Can chup:

- [ ] Terminal hien dashboard JSON duoc format ra, khong bao loi.
- [ ] Terminal hien `Day B YAML OK`.

Neu `yaml` chua co trong Python, co the bo qua lenh YAML va chup truc tiep file YAML trong VS Code.

## 3. Test endpoint `/metrics` cua app

Neu app dang chay trong Kubernetes tu Day A, chay:

```powershell
kubectl port-forward svc/w9-demo-app -n w9-demo 8080:80
```

Mo terminal khac:

```powershell
curl http://localhost:8080/metrics
```

Can chup:

- [ ] Terminal co metric `http_requests_total`.
- [ ] Terminal co metric `http_request_duration_seconds_bucket`, `http_request_duration_seconds_count` hoac `http_request_duration_seconds_sum`.

Neu chua co Kubernetes, co the chay app local:

```powershell
cd E:\cloud\W9
py -m pip install -r app\requirements.txt
py app\app.py
```

Mo terminal khac:

```powershell
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/metrics
```

Can chup:

- [ ] App local tra ve `BudgetBot W9 Demo v1`.
- [ ] `/health` tra ve `healthy`.
- [ ] `/metrics` co Prometheus metrics.

## 4. Apply OpenTelemetry Collector config neu co cluster

Chay:

```powershell
kubectl apply -f day-b/otel/collector-config.yaml
kubectl get configmap otel-collector-config -n w9-demo
kubectl describe configmap otel-collector-config -n w9-demo
```

Can chup:

- [ ] ConfigMap `otel-collector-config` ton tai trong namespace `w9-demo`.
- [ ] Noi dung co `receivers`, `exporters`, `service`, `pipelines`.

Luu y: file nay la ConfigMap cau hinh collector. Neu cluster chua cai OpenTelemetry Collector Deployment/Helm chart, day la bang chung cau hinh, chua phai collector pod dang chay.

## 5. Apply Prometheus SLO/Burn Rate rule neu co Prometheus Operator

Chay:

```powershell
kubectl apply -f day-b/alert-rules/slo-burn-rate.yaml
kubectl get prometheusrule -n monitoring
kubectl describe prometheusrule w9-slo-burn-rate -n monitoring
```

Can chup:

- [ ] `prometheusrule` co item `w9-slo-burn-rate`.
- [ ] Trong describe co alert `HighErrorBudgetBurnFast`.
- [ ] Trong describe co alert `HighErrorBudgetBurnSlow`.

Neu cluster khong co Prometheus Operator CRD, lenh apply co the loi `no matches for kind "PrometheusRule"`. Khi do chup loi nay va chup file YAML, giai thich voi mentor: "Rule da viet dung dinh dang Prometheus Operator, can cai Prometheus Operator de apply."

## 6. Prometheus evidence

Neu co Prometheus UI:

1. Mo Prometheus UI.
2. Vao tab `Graph` hoac `Query`.
3. Chay query:

```promql
http_requests_total
```

4. Chay them query error rate:

```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))
```

Can chup:

- [ ] Query `http_requests_total` co ket qua.
- [ ] Query error rate chay duoc, ke ca gia tri rong neu chua co loi 5xx.
- [ ] Trang `Status > Targets` co target scrape app neu ban da cau hinh Prometheus scrape.

Neu Prometheus chua scrape app, chup `/metrics` endpoint va YAML collector/rule de chung minh phan code va cau hinh da san sang.

## 7. Grafana dashboard evidence

Thao tac tren Grafana:

1. Mo Grafana UI.
2. Vao `Dashboards`.
3. Chon `New` hoac `Import`.
4. Import file `day-b/dashboards/grafana-dashboard.json`.
5. Chon datasource Prometheus.
6. Mo dashboard `W9 Demo Observability`.

Can chup:

- [ ] Man hinh import dashboard thanh cong.
- [ ] Dashboard co title `W9 Demo Observability`.
- [ ] 4 panel: `Total Requests`, `Error Rate`, `Request Latency`, `App Health`.
- [ ] Neu co data, chup panel co du lieu. Neu chua co data, chup panel va giai thich Prometheus chua scrape du lieu.

## 8. Evidence toi thieu neu chua co cluster/Prometheus/Grafana

Neu hom nay chua co moi truong de deploy that, van co the nop:

- [ ] Screenshot `curl http://localhost:5000/metrics` khi chay Flask local.
- [ ] Screenshot `py -m json.tool day-b\dashboards\grafana-dashboard.json` thanh cong.
- [ ] Screenshot `Day B YAML OK`.
- [ ] Screenshot file `collector-config.yaml`.
- [ ] Screenshot file `slo-burn-rate.yaml`.
- [ ] Screenshot file `grafana-dashboard.json` co 4 panel.

## 9. Goi y thu tu chup anh de nop mentor

1. VS Code: `app.py` dang co `/metrics`.
2. Terminal: app local hoac port-forward va `curl /metrics`.
3. VS Code: `collector-config.yaml`.
4. Terminal: `kubectl get configmap otel-collector-config -n w9-demo`.
5. VS Code: `slo-burn-rate.yaml`.
6. Terminal: `kubectl get prometheusrule -n monitoring` hoac screenshot loi CRD neu chua cai Prometheus Operator.
7. Grafana: dashboard `W9 Demo Observability` co 4 panel.
8. Prometheus: query `http_requests_total`.

## Tom tat cau noi voi mentor

"Day B cua em them observability cho app. App expose `/metrics` theo Prometheus format, OTel Collector config co OTLP va Prometheus receiver, PrometheusRule co fast/slow burn-rate alert cho SLO, va Grafana dashboard co 4 panel: total requests, error rate, latency va app health. Neu co cluster day du, em apply config va import dashboard; neu chua co, em da validate file va test endpoint metrics local."
