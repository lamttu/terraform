# Terraform

## List of resources to go through
- [x] https://learn.hashicorp.com/collections/terraform/aws-get-started
- [x] Default tags (in default tag branch)
- [x] [IAM Role](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy?in=terraform/aws) (in the iam-role branch)
- [ ] [Lambda API Gateway](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws)(https://github.com/lamttu/go-api)
- [x] [DynamoDB scale](https://learn.hashicorp.com/tutorials/terraform/aws-dynamodb-scale?in=terraform/aws)
- [ ] [The HCL language](https://learn.hashicorp.com/collections/terraform/configuration-language)
  - [x] [Secret values](https://learn.hashicorp.com/tutorials/terraform/sensitive-variables?in=terraform/configuration-language)
  - [x] [Define infra with TF resources](https://learn.hashicorp.com/tutorials/terraform/resource?in=terraform/configuration-language)
  - [ ] [Play around with a provider](https://learn.hashicorp.com/tutorials/terraform/provider-use?in=terraform/configuration-language)
  - [x] [Variables](https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language)
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
- `depends_on` can be added to manage dependencies between resources
```
  resource "aws_instance" "example_a" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}

resource "aws_instance" "example_b" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  depends_on    = aws_instance.example_a
}
```

### Variables
- You can parameterise your terraform with variables. This is usually put in `variables.tf` and refer to by `var.variable_name`
```
variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC."
  type        = bool
  default     = false
}

```
- Usually variables are put in `.tfvars` files and then passed in the cli using `terraform apply -var-file="dev.tfvars"`
- Terraform supports `string`, `number`, `bool`, `list(<type>)`, `set(<type>)`, `map(<type>)`, `object({ <name> = <type>})`, `tuple([ <type> , ...])`
- Variables have to be literal values and can't be expressions or other variables
- You can have [custom condition check](https://www.terraform.io/language/expressions/custom-conditions)
```
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

```
- How to use map variables
```
variable "resource_map" {
  type = map(string)
  description = "Resource map for each environment"
  default = {
    uat = "www.uat.com"
    prod = "www.prod.com"
  }
}

# When used:
endpoint = resource_map["uat"]

```
### String interpolation
- `name = "this-is-text-${var.my_variable}-${var.another_variable}"`

### Locals
- Locals can be used to refer to an expression or value. It's like a name for the result of any Terraform expresion. Example: 
```
locals {
  name_suffix = "${var.resource_tags["project"]}-${var.environment}"
}

resource "random_pet" "random_name" {
  name = "example-${local.name_suffix}
}
```

### Data block

- Data block is used to query data. One common use case is to query arn of secrets in AWS
```
data "aws_secretsmanager_secret" "api_key" {
  name = "api_key"
}
```

### Remote state

### Environment parity

### Dynamic block

### Import existing infra into Terraform

### Module

## Resources
- https://learn.hashicorp.com/collections/terraform/aws