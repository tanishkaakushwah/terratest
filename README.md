# 🧪Terratest for Terraform (Azure)

This repository demonstrates how to use **Terratest** to validate **Terraform-provisioned Azure infrastructure** by running real tests against deployed resources and cleaning them up automatically.

---

## 📌 What this project does

* Provisions Azure infrastructure using **Terraform**
* Validates infrastructure using **Terratest (Go)**
* Runs real checks (not just `terraform apply`)
* Automatically destroys resources after tests

---

## 🧱 Infrastructure Covered

* Azure Resource Groups
* Azure Virtual Machine (Frontend)
* Public IP
* Network Security Group
* Azure Key Vault + Secrets
* NGINX running on VM (Port 80)

---

## 🧪 Test Cases Implemented

### ✅ Test Case 1: Infrastructure Validation

* Verifies that **Resource Groups are created**
* Uses Terraform `output` blocks as test inputs

```go
output := terraform.OutputMap(t, tf, "resource_group_names")
if len(output) == 0 {
    t.Fatal("resource_group_names should not be empty")
}
```

---

### ✅ Test Case 2: Application Validation

* Fetches **Frontend VM public IP**
* Sends HTTP request to port **80**
* Verifies VM is reachable and returns **HTTP 200**

```go
http_helper.HttpGetWithRetryWithCustomValidation(
    t,
    url,
    nil,
    maxRetries,
    timeBetweenRetries,
    func(status int, _ string) bool {
        return status == 200
    },
)
```

---

## 🧰 Tech Stack

* **Terraform** – Infrastructure as Code
* **Terratest** – Infrastructure testing framework
* **Go** – Test runner
* **Azure** – Cloud platform
* **NGINX** – Web server for validation

---

## 📁 Project Structure

```
.
├── terraform/
│   └── environments/
│       └── dev/
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│
├── test/
│   └── terraform_test.go
│
└── README.md
```

---

## ⚙️ Prerequisites

* Go **>= 1.25.x**
* Terraform **>= 1.x**
* Azure subscription
* Azure CLI logged in (or OIDC in CI)
* Proper RBAC permissions

---

## 🚀 How to Run Tests

### 1️⃣ Initialize Go modules

```bash
go mod tidy
```

### 2️⃣ Run Terratest

```bash
go test ./test -v -timeout 30m
```

> ⚠️ Azure resource creation is slow — increasing timeout is required.

---

## 🔥 Key Challenges & Learnings

### 1. Go Version Mismatch

```
go.mod requires go >= 1.25.5
```

✔ Fixed by upgrading Go version.

---

### 2. Azure Key Vault RBAC Delay

```
ForbiddenByRbac
```

✔ Azure RBAC is eventually consistent
✔ Fixed using `time_sleep` after role assignment

---

### 3. Terratest Timeout Panic

```
panic: test timed out after 10m0s
```

✔ Fixed using:

```bash
go test -timeout 30m
```

---

### 4. Output-Driven Testing

Terratest relies on **Terraform outputs**, not internal state.

✔ Outputs act as the **contract** between Terraform and tests.

---

## 🧹 Automatic Cleanup

All resources are destroyed automatically after tests:

```go
defer terraform.Destroy(t, tf)
```

Example output:

```
Destroy complete! Resources: 25 destroyed.
```

This prevents:

* Cloud cost leaks
* Orphaned infrastructure
* Manual cleanup

---

## 🏭 Why Terratest Matters in Production

* Catches real Azure issues (RBAC, firewall, boot failures)
* Verifies infrastructure behavior, not just creation
* Builds confidence in CI/CD pipelines
* Prevents broken deployments reaching production
* Enables **testable Infrastructure as Code**

---

## 🔑 Key Takeaway

> **Terraform provisions infrastructure.
> Terratest proves it actually works.**

---

## 📚 References

* Terratest Docs: [https://terratest.gruntwork.io/](https://terratest.gruntwork.io/)
* Terraform Docs: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)
* Azure Docs: [https://learn.microsoft.com/azure](https://learn.microsoft.com/azure)

