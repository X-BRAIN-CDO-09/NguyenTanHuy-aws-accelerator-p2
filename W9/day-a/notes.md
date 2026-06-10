# Day A Notes

CI/CD la chuoi hanh dong tu dong giup code di tu may dev den moi truong chay mot cach co kiem soat. Trong project nay, CI gom checkout code, cai Python, cai dependency, compile app va build Docker image. Buoc nay chua push image that vi day la repo hoc tap.

GitOps la cach van hanh ha tang va Kubernetes bang Git. Thay vi sua truc tiep trong cluster, ta sua manifest trong repo. ArgoCD doc repo, so sanh trang thai mong muon voi trang thai thuc te va sync vao cluster.

ArgoCD Application mo ta repo nao, path nao, branch nao va cluster/namespace nao se duoc sync. App of Apps la pattern tao mot root Application de quan ly nhieu Application con. Cach nay phu hop khi repo lon hon va co nhieu ung dung hoac nhieu layer.

Readiness probe tra loi cau hoi pod da san sang nhan traffic chua. Liveness probe tra loi cau hoi process con song tot khong. Neu liveness fail, kubelet restart container. Neu readiness fail, Service tam thoi khong gui traffic den pod do.

Rollback trong GitOps nen uu tien `git revert` vi Git van la nguon su that. `kubectl rollout undo` co the huu ich trong tinh huong khan cap, nhung sau do can dua thay doi ve Git de tranh ArgoCD sync lai trang thai loi.
