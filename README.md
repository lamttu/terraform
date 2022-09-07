# Terraform

## List of resources to go through
- [x] https://learn.hashicorp.com/collections/terraform/aws-get-started

## Useful commands
- `terraform init`
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply --auto-approve -var "variable_name=ThisIsAVariable"`
- `terraform output` 

## Run terraform locally at Xero
- `awsume xero-ps-paas-test`
- Run the terraform commands
  - `terraform init`: Initialise terraform - this needs to be run once only
  - `terraform fmt`: Format terraform nicely
  - `terraform validate`: Validate we have valid terraform
  - `terraform apply --auto-approve`: Provision the resources