# Day B - Observability

## Muc tieu ngay

Day B them lop quan sat he thong cho app: metrics, logs, traces, OpenTelemetry Collector, Prometheus alert rule va Grafana dashboard.

## Kien thuc chinh

- Monitoring cho biet he thong co dang loi hay khong.
- Observability giup tra loi vi sao he thong loi.
- Logs ghi lai su kien chi tiet.
- Metrics la so lieu tong hop theo thoi gian.
- Traces theo doi mot request di qua cac service.
- OpenTelemetry Collector nhan, xu ly va xuat telemetry.
- Prometheus luu va query metrics bang PromQL.
- Grafana hien thi dashboard.
- SLI la chi so do do tin cay, SLO la muc tieu, Error Budget la phan loi duoc phep, Burn Rate la toc do tieu error budget.

## File trong thu muc nay dung de lam gi

- `otel/collector-config.yaml`: cau hinh OpenTelemetry Collector voi OTLP va Prometheus receiver.
- `alert-rules/slo-burn-rate.yaml`: PrometheusRule mau cho fast burn va slow burn.
- `dashboards/grafana-dashboard.json`: dashboard Grafana mau.
- `notes.md`: ly thuyet chi tiet bang tieng Viet.
- `evidence.md`: checklist anh can chup.

## Cach demo ngan

1. Mo `/metrics` cua app de thay metrics Prometheus.
2. Giai thich Collector nhan OTLP va scrape metrics.
3. Import dashboard JSON vao Grafana.
4. Mo rule SLO burn rate trong Prometheus hoac Prometheus Operator.

## Cau hoi mentor co the hoi

- Monitoring khac Observability o diem nao?
- Vi sao can ca logs, metrics va traces?
- Burn rate lien quan gi den error budget?
- Tai sao alert nen dung multi-window thay vi mot nguong don gian?
