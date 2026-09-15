# Infra

This folder provisions a fully private Azure VM for **Capacity Planning and Optimization**.

## Deployment spec

- OS: Red Hat Enterprise Linux 8 (64-bit)
- VM size: `Standard_D2s_v3`
- Disk: 150 GB HDD
- Host name: `pwauswpdstd0006`
- Region: `westus2`
- VNet: `10.0.0.0/16`
- Subnet: `10.0.0.0/24`
- No public IP
- No Bastion
- Access via VPN/private connectivity only

## Notes

- SSH is allowed only from the CIDR you provide in `allowed_ssh_source_cidr`.
- The Red Hat image uses the Azure Marketplace plan block; Azure may require marketplace terms acceptance on the subscription.
- Supply your SSH public key through `admin_ssh_public_key`.

## Deploy locally

```bash
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
