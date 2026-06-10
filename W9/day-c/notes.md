# Day C Notes

Progressive Delivery la cach dua thay doi ra moi truong that theo tung buoc nho, co quan sat va co dieu kien dung. Muc tieu la giam blast radius: neu version moi loi, chi mot phan traffic bi anh huong.

Canary Deployment la chien luoc phat hanh version moi cho mot ty le nho nguoi dung truoc. Neu metrics tot, tang dan traffic. Neu metrics xau, dung rollout va rollback.

Argo Rollouts mo rong Kubernetes bang Rollout CRD. Thay vi Deployment co rolling update co ban, Rollout co canary steps, pause, analysis, blue-green va kha nang rollback nang cao.

AnalysisTemplate la noi dinh nghia metric can kiem tra. Trong project nay, metric `success-rate` query Prometheus bang `http_requests_total`. Neu success rate nho hon 0.95, analysis fail. `failureLimit: 1` nghia la chi can vuot qua so lan fail cho phep thi rollout bi dung.

Abort Criteria la dieu kien noi rang ban moi khong du an toan de tiep tuc. Vi du error rate cao, latency p95 tang manh, success rate thap hoac burn rate tieu error budget qua nhanh.

Canary va Burn Rate lien ket rat tot. Canary dung metric ngan han de chan version xau truoc khi no dot error budget cua toan he thong. Burn rate alert dung cho van hanh dai hon, con analysis trong rollout dung cho quyet dinh phat hanh ngay luc deploy.
