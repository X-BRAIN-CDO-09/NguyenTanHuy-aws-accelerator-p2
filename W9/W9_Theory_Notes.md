# W9 Theory Notes - GitOps, Observability, Canary

## DAY A: CI/CD va GitOps

CI/CD giup dua thay doi tu code den moi truong chay mot cach co kiem soat. CI tap trung vao kiem tra code: install dependency, lint/test/compile va build artifact. CD tap trung vao dua artifact hoac manifest den moi truong.

GitHub Actions la cong cu CI/CD chay theo event nhu `push` va `pull_request`. Trong W9, workflow mau checkout repo, setup Python, install requirements, compile app va build Docker image. Day la bang chung rang app co the build duoc truoc khi deploy.

Plan on PR va Apply on Merge la pattern quan trong trong DevOps. Voi ha tang, PR nen chay plan de thay truoc tac dong. Khi merge vao branch chinh, pipeline moi apply. Trong GitOps, y tuong nay tuong tu: PR cho review manifest, merge xong ArgoCD sync trang thai moi.

GitOps dat Git lam nguon su that. Cluster khong phai noi de sua tay lau dai. Neu muon thay doi replica, image tag, config, ta sua YAML trong Git. ArgoCD so sanh desired state trong Git voi live state trong cluster, sau do sync.

ArgoCD Application khai bao repoURL, path, targetRevision va destination. Automated sync voi `prune` va `selfHeal` giup tu dong xoa tai nguyen khong con trong Git va sua drift trong cluster.

App of Apps la pattern dung mot root Application quan ly nhieu Application con. Khi he thong co nhieu app hoac nhieu layer nhu platform, monitoring, app, rollout, pattern nay giup bootstrap de hon.

Sync Waves la ky thuat sap xep thu tu sync bang annotation cua ArgoCD. Vi du namespace va CRD can di truoc app. Neu khong co thu tu, app co the fail vi dependency chua ton tai.

Rollback trong GitOps nen uu tien `git revert`. Khi revert commit, ArgoCD sync cluster ve trang thai truoc do va lich su van ro rang. `kubectl rollout undo` nhanh trong su co khan cap, nhung neu Git khong doi, ArgoCD co the sync lai version loi. Vi vay sau thao tac khan cap phai cap nhat Git.

## DAY B: Observability

Monitoring tra loi cau hoi "he thong co dang on khong". Observability tra loi them cau hoi "vi sao no khong on". Mot he thong observable cho phep debug van de moi ma khong can deploy them code qua nhieu lan.

Logs la cac dong su kien. Logs tot nen co timestamp, level, request id va thong tin ngu canh. Logs phu hop de doc chi tiet loi.

Metrics la so lieu tong hop theo thoi gian, vi du request per second, error rate, latency p95, CPU, memory. Metrics phu hop cho dashboard va alert vi nhe va de query.

Traces mo ta hanh trinh cua mot request qua nhieu service. Moi span bieu dien mot buoc xu ly. Traces giup tim service nao cham hoac loi trong kien truc phan tan.

OpenTelemetry la chuan mo cho telemetry. No gom API, SDK, convention va Collector. Muc tieu la tranh khoa chat vao mot vendor.

OTel Collector la thanh phan nhan, xu ly va xuat telemetry. Receivers nhan du lieu, processors xu ly, exporters gui den backend. Trong project nay co OTLP receiver, Prometheus receiver va logging exporter.

Prometheus scrape endpoint `/metrics`, luu du lieu time-series va query bang PromQL. Counter `http_requests_total` dung de tinh request rate va error rate. Histogram `http_request_duration_seconds` dung de tinh latency percentile.

Grafana ket noi Prometheus de ve dashboard. Dashboard nen co chi so gan voi nguoi dung: traffic, loi, latency va health.

Loki thu thap logs va thuong duoc dung voi Grafana. Neu Prometheus tra loi bang metrics, Loki giup doc log lien quan trong cung mot man hinh van hanh.

SLI la Service Level Indicator, chi so do chat luong dich vu. SLO la Service Level Objective, muc tieu cho SLI. Vi du SLI la success rate, SLO la 99%.

Error Budget la phan loi duoc phep. Voi SLO 99%, error budget la 1%. Neu tieu qua nhanh, team nen dung release moi va uu tien on dinh.

Burn Rate la toc do tieu error budget. Multi-window burn rate alert ket hop cua so ngan va dai. Fast 1h x 5m phat hien su co dot ngot. Slow 6h x 30m phat hien su co nhe nhung keo dai. Cach nay can bang giua bat loi nhanh va giam alert nhieu.

## DAY C: Progressive Delivery va Canary

Progressive Delivery la phat hanh co kiem soat. Thay vi dua version moi cho 100% traffic ngay lap tuc, ta dua tung phan va do chat luong.

Canary Deployment dua version moi cho mot phan nho traffic truoc. Neu canary tot, tang traffic len 50%, roi 100%. Neu canary xau, dung lai va rollback.

Argo Rollouts la controller mo rong Kubernetes cho progressive delivery. Rollout CRD thay Deployment khi can canary, blue-green, pause, manual promotion va analysis tu dong.

Rollout CRD trong W9 co replicas 2 va canary steps: setWeight 10, pause 1m, analysis, setWeight 50, pause 1m, setWeight 100. Dieu nay tao co hoi quan sat ban moi truoc khi day het traffic.

AnalysisTemplate khai bao metric de danh gia rollout. Provider Prometheus cho phep chay PromQL. Trong project nay metric `success-rate` tinh ty le request khong phai 5xx tren tong request.

Prometheus Query trong analysis can ro rang va lien quan den SLO. Vi du success rate >= 0.95 la dieu kien toi thieu de tiep tuc. Trong thuc te, co the them latency p95, saturation hoac burn rate.

Abort Criteria la dieu kien dung rollout. Neu success rate thap, error rate cao, latency tang hoac burn rate vuot nguong, rollout nen abort. Muc tieu la bao ve nguoi dung va error budget.

Auto Abort va Auto Rollback giup giam thoi gian phan ung. He thong khong doi nguoi truc phai nhin dashboard moi dung release, ma co the tu dong dung khi metric xau.

Canary lien ket chat voi Burn Rate. Burn rate cho biet version moi co dang tieu error budget nhanh khong. Dua burn rate vao analysis giup rollout khong chi dua tren test ky thuat ma dua tren muc tieu do tin cay cua dich vu.
