# Terraform

## List of resources to go through
- [x] https://learn.hashicorp.com/collections/terraform/aws-get-started
- [x] Default tags (in default tag branch)
- [x] [IAM Role](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy?in=terraform/aws) (in the iam-role branch)
- [ ] [Lambda API Gateway](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws)(https://github.com/lamttu/go-api)
- [x] [DynamoDB scale](https://learn.hashicorp.com/tutorials/terraform/aws-dynamodb-scale?in=terraform/aws)
- [ ] [The HCL language](https://learn.hashicorp.com/collections/terraform/configuration-language)
- [ ] [Modules](https://learn.hashicorp.com/collections/terraform/modules)
- [ ] [States](https://learn.hashicorp.com/collections/terraform/state)
- [ ] [General knowledge check](https://learn.hashicorp.com/tutorials/terraform/associate-study?in=terraform/certification)

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

## Terraform things
- `.terraform.lock.hcl` contains the hashes for the provider versions. You should never directly modify it.
If you want to update the provider, run `terraform init -upgrade`

### Remote state

### Environment parity

### Dynamic block

### Import existing infra into Terraform

### Module

## Resources
- https://learn.hashicorp.com/collections/terraform/aws