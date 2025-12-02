# Kubernetes Setup cho CI/CD

## Cách 1: Sử dụng Kubeconfig hiện có (Đơn giản nhất)

### Bước 1: Encode kubeconfig

```bash
cat ~/.kube/config | base64 | pbcopy
```

### Bước 2: Thêm vào GitHub Secrets

- Vào: Settings → Secrets and variables → Actions
- Name: `KUBECONFIG_DATA`
- Value: Paste giá trị base64

---

## Cách 2: Tạo ServiceAccount riêng (Recommended cho Production)

### Bước 1: Tạo namespace

```bash
kubectl create namespace demo
```

### Bước 2: Apply ServiceAccount

```bash
kubectl apply -f github-actions-serviceaccount.yaml
```

### Bước 3: Lấy token và tạo kubeconfig

#### Kubernetes < 1.24:

```bash
TOKEN=$(kubectl get secret -n demo github-actions-deployer-token -o jsonpath='{.data.token}' | base64 --decode)
```

#### Kubernetes >= 1.24:

```bash
TOKEN=$(kubectl create token github-actions-deployer -n demo --duration=87600h)
```

### Bước 4: Tạo kubeconfig mới

```bash
# Lấy cluster info
CLUSTER_NAME=$(kubectl config current-context)
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_CA=$(kubectl config view --minify --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

# Tạo kubeconfig file
cat > github-actions-kubeconfig.yaml <<EOF
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_SERVER}
contexts:
- name: github-actions@${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    user: github-actions-deployer
    namespace: demo
current-context: github-actions@${CLUSTER_NAME}
users:
- name: github-actions-deployer
  user:
    token: ${TOKEN}
EOF
```

### Bước 5: Encode và thêm vào GitHub

```bash
cat github-actions-kubeconfig.yaml | base64 | pbcopy
```

Sau đó thêm vào GitHub Secrets với name: `KUBECONFIG_DATA`

### Bước 6: Clean up (xóa file local)

```bash
rm github-actions-kubeconfig.yaml
```

---

## Kiểm tra Setup

### Test kubeconfig

```bash
# Decode để test
echo "$KUBECONFIG_DATA" | base64 --decode > test-kubeconfig.yaml
export KUBECONFIG=test-kubeconfig.yaml

# Test connection
kubectl cluster-info
kubectl get nodes
kubectl get ns demo

# Xóa test file
rm test-kubeconfig.yaml
```

### Test deployment thủ công

```bash
# Vào thư mục root
cd /Users/macbookairm1/Desktop/angular-v20/demo-ci-cd

# Test Helm chart
helm install demo-frontend demo-frontend-chart \
  --namespace demo \
  --create-namespace \
  --dry-run --debug
```

---

## Cloud Provider Specific

### Google Kubernetes Engine (GKE)

```bash
gcloud container clusters get-credentials [CLUSTER_NAME] --region [REGION]
cat ~/.kube/config | base64 | pbcopy
```

### AWS EKS

```bash
aws eks update-kubeconfig --name [CLUSTER_NAME] --region [REGION]
cat ~/.kube/config | base64 | pbcopy
```

### Azure AKS

```bash
az aks get-credentials --resource-group [RG] --name [CLUSTER_NAME]
cat ~/.kube/config | base64 | pbcopy
```

### DigitalOcean

```bash
doctl kubernetes cluster kubeconfig save [CLUSTER_NAME]
cat ~/.kube/config | base64 | pbcopy
```

---

## Troubleshooting

### Lỗi: "The connection to the server localhost:8080 was refused"

→ Cluster không chạy hoặc kubeconfig sai

### Lỗi: "error: You must be logged in to the server (Unauthorized)"

→ Token hết hạn hoặc ServiceAccount không có quyền

### Lỗi: "Error from server (Forbidden)"

→ ServiceAccount thiếu permissions, cần update RBAC rules
