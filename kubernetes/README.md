# ☸️ Kubernetes Deployments
# Triển khai trên Kubernetes

Deploying Oracle on Kubernetes is handled via StatefulSets to ensure data persistence.
*Việc triển khai Oracle trên Kubernetes được xử lý thông qua StatefulSet để đảm bảo tính bền vững của dữ liệu.*

- **StatefulSet & Services:** Please refer to `docs/08-ecosystem/01_kubernetes_statefulset.yaml` for a complete example of running Oracle 23c Free Edition in a K8s cluster.
  *(Vui lòng tham khảo file YAML ở Stage 8 để xem ví dụ hoàn chỉnh về cách chạy Oracle 23c trong cụm K8s).*
- **Oracle Operator:** For production, use the official [Oracle Database Operator for Kubernetes](https://github.com/oracle/oracle-database-operator).