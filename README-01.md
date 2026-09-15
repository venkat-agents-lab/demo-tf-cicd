# demo-tf-cicd

Terraform repository for provisioning a fully private Azure VM running **Red Hat Enterprise Linux 8 (64-bit)** for **Capacity Planning and Optimization**.

GitHub repository target:

- `https://github.com/venkat-agents-lab/demo-tf-cicd`

## Requested deployment spec

- Application: Capacity Planning and Optimization
- OS: Red Hat Enterprise Linux 8 (64-bit)
- VM size: `Standard_D2s_v3`
- Disk: 150 GB HDD
- Host name: `pwauswpdstd0006`
- Region: `westus2`
- VNet: `10.0.0.0/16`
- Subnet: `10.0.0.0/24`
- Access model: fully private / VPN-only
- No public IP anywhere
- No Bastion
- Azure auth: GitHub OIDC

## Repository structure

```text
demo-tf-cicd/
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
├── infra/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
├── .github/
│   └── workflows/
│       └── terraform.yml
└── .gitignore
```

## How deployment works

1. **Bootstrap the Terraform state backend**
   - Run the `bootstrap/` stack once to create the Azure Storage account and container used for remote state.
   - Capture the backend values from the bootstrap outputs.

2. **Configure GitHub OIDC**
   - Create an Azure app registration / service principal with a federated credential for this repo.
   - Grant it access to the subscription and to the state storage account blob container.

3. **Run the GitHub Actions workflow**
   - Pull requests run `terraform plan`.
   - Manual workflow dispatch can run `terraform apply`.

## Required GitHub secrets / variables

### Azure OIDC

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

### Terraform state backend

- `TF_STATE_RESOURCE_GROUP`
- `TF_STATE_STORAGE_ACCOUNT`
- `TF_STATE_CONTAINER`
- `TF_STATE_KEY`

### VM inputs

- `TF_VAR_admin_username`
- `TF_VAR_admin_ssh_public_key`
- `TF_VAR_allowed_ssh_source_cidr`

## Notes

- This repository does **not** create a public IP or Bastion host.
- RDP is not used; the Linux VM is intended for private SSH access over VPN.
- The workflow uses GitHub OIDC for Azure authentication.
- The Azure Storage backend used for Terraform state is a separate bootstrap concern.

## Deploy flow

### Bootstrap state backend

```bash
cd bootstrap
terraform init
terraform apply
```

### Deploy VM

```bash
cd infra
terraform init \
  -backend-config="resource_group_name=${TF_STATE_RESOURCE_GROUP}" \
  -backend-config="storage_account_name=${TF_STATE_STORAGE_ACCOUNT}" \
  -backend-config="container_name=${TF_STATE_CONTAINER}" \
  -backend-config="key=${TF_STATE_KEY}" \
  -backend-config="subscription_id=${AZURE_SUBSCRIPTION_ID}" \
  -backend-config="tenant_id=${AZURE_TENANT_ID}" \
  -backend-config="client_id=${AZURE_CLIENT_ID}" \
  -backend-config="use_oidc=true" \
  -backend-config="use_azuread_auth=true"
terraform plan
terraform apply
```
