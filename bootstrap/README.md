# Bootstrap

This folder creates the Azure Storage resources used for Terraform remote state.

## Deploy

```bash
terraform init
terraform apply
```

## Outputs

Use the output values to populate GitHub secrets for the `infra/` workflow:

- `TF_STATE_RESOURCE_GROUP`
- `TF_STATE_STORAGE_ACCOUNT`
- `TF_STATE_CONTAINER`
- `TF_STATE_KEY`
