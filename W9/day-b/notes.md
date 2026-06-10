# Day B Notes

Monitoring la viec theo doi mot tap chi so da biet truoc, vi du CPU, memory, request rate, error rate. Observability rong hon: tu tin hieu dau ra cua he thong, ta co the suy luan trang thai ben trong va tim nguyen nhan goc.

Ba tin hieu chinh la logs, metrics va traces. Logs phu hop de xem su kien cu the. Metrics phu hop de xem xu huong, alert va dashboard. Traces phu hop de debug request di qua nhieu service, dac biet khi kien truc co microservices.

OpenTelemetry la bo chuan vendor-neutral de tao, thu thap va xuat telemetry. OTel Collector la thanh phan trung gian, nhan du lieu tu app hoac scrape endpoint, sau do xuat sang backend nhu Prometheus, Loki, Jaeger hoac logging exporter.

Prometheus la time-series database va alert engine. App expose `/metrics`, Prometheus scrape theo chu ky. PromQL cho phep tinh request rate, error rate va latency percentile.

Grafana dung de hien thi dashboard. Dashboard trong project gom Total Requests, Error Rate, Request Latency va App Health. Khi demo, can noi ro dashboard khong chi de dep ma de giam thoi gian phat hien va xu ly su co.

SLI la chi so do trai nghiem nguoi dung, vi du success rate hoac p95 latency. SLO la muc tieu cho SLI, vi du 99% request thanh cong trong 30 ngay. Error Budget la 1% con lai duoc phep loi. Burn Rate la toc do tieu error budget. Neu burn rate cao, can alert som.

Multi-window burn rate alert hay dung hai lop: fast alert de bat su co nghiem trong trong cua so ngan nhu 1h x 5m, slow alert de bat su co am i trong cua so dai nhu 6h x 30m. Cach nay giam false positive va van bao ve SLO.
