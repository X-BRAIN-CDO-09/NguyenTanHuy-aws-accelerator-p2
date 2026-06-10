# Day C - Canary va Progressive Delivery

## Muc tieu ngay

Day C bien deployment thong thuong thanh progressive delivery bang Argo Rollouts. Ban moi se duoc dua vao tung phan tram traffic va duoc kiem tra bang Prometheus query truoc khi di tiep.

## Kien thuc chinh

- Progressive Delivery dua thay doi ra production tung buoc va co dieu kien kiem soat.
- Canary Deployment cho mot phan nho traffic dung version moi truoc.
- Argo Rollouts cung cap Rollout CRD thay the Deployment khi can canary/blue-green.
- AnalysisTemplate dinh nghia metric kiem tra rollout.
- Abort Criteria la dieu kien dung rollout khi chat luong khong dat.
- Auto rollback giup dua traffic ve version cu khi metric xau.

## File trong thu muc nay dung de lam gi

- `rollout/rollout.yaml`: Rollout CRD voi canary steps 10%, analysis, 50%, 100%.
- `rollout/service.yaml`: Service tro den pod cua rollout.
- `analysis-template/prometheus-analysis.yaml`: AnalysisTemplate query success rate tu Prometheus.
- `notes.md`: ly thuyet chi tiet.
- `evidence.md`: checklist anh can chup.

## Cach demo ngan

1. Apply AnalysisTemplate va Rollout.
2. Chay `kubectl argo rollouts get rollout w9-demo-rollout -n w9-demo`.
3. Giai thich canary dung lai o buoc analysis neu success rate nho hon 95%.
4. Cho thay Prometheus query duoc dung lam dieu kien auto abort.

## Cau hoi mentor co the hoi

- Canary khac rolling update nhu the nao?
- AnalysisTemplate giup giam rui ro ra sao?
- Khi nao nen abort rollout?
- Burn rate co the dung lam metric canary khong?
