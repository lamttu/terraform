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
  - [x] [Secrets](https://learn.hashicorp.com/tutorials/terraform/sensitive-variables?in=terraform/configuration-language)
  - [x] [Locals](https://learn.hashicorp.com/tutorials/terraform/locals?in=terraform/configuration-language)
  - [x] [Query data](https://learn.hashicorp.com/tutorials/terraform/data-sources?in=terraform/configuration-language)
  - [x] [count](https://developer.hashicorp.com/terraform/tutorials/configuration-language/count)
  - [x] [for_each](https://developer.hashicorp.com/terraform/tutorials/configuration-language/for-each)
- [ ] [Modules](https://learn.hashicorp.com/collections/terraform/modules)
  - [ ] https://developer.hashicorp.com/terraform/tutorials/modules/module
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

### Output
- Output allows you export data about the resources
```
resource "aws_db_instance" "database" {
  allocated_storage = 5
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name = aws_db_subnet_group.private.name

  skip_final_snapshot = true
}

output "database-ip" {
  description = "IP of the databse"
  value = aws_db_instance.database.public_ip
}
```

### Data block

- Data block is used to query data. One common use case is to query arn of secrets in AWS
```
data "aws_secretsmanager_secret" "api_key" {
  name = "api_key"
}
```
- There are multiple use cases for this. For example, querying the AMI ID for an EC2 instance
```
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```


### Manage similar resources

#### 1. Using count
Example code is in the `count` branch

- Define the number of resources as a variable
- Use `count` in the resource block to specify how many instances we want
- `count.index` gives you the index of the resource. This is useful when we want to use the index to assign different values to something.
```
resource "aws_instance" "app" {
  count = var.instances_per_subnet * length(module.vpc.private_subnets)
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  ## ...
}
```
- Use `*` to specify all instances of the resource. Example: `aws_resource.app.*.id`: gets all the IDs of all the EC2 instances
#### 2. Using for each
- Steps to use `for_each`:
  - Define a variable (map, list, or set)
  - Add a `for_each` attribute in the resource you want to create

Example:
```
variable "project" {
  type = map(any)

  default = {
    project-1 = {
      this-inner-key = this-inner-value
    }

    project-2 = {

    }
  }
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.9.0"

  for_each = var.project

  name        = "web-server-sg-${each.key}-${each.value.environment}"
  description = "Security group for web-servers with HTTP ports open within VPC"
  # We can get access to different resources created by for_each using each.key
  vpc_id      = module.vpc[each.key].vpc_id

  ingress_cidr_blocks = module.vpc[each.key].public_subnets_cidr_blocks
}
```

- When we use `for_each`, we get access to `each.key` and `each.value`. These are the key value pairs defined in the variable. 
In the example below, the `key` will be "project-1" and "project-2". To get to `this-inner-value`, we can do `each.value.this-inner-key`

- When you use `for_each` with a list or set, `each.key` is the index of the item in the collection, and `each.value` is the value of the item.
- We can get access to the specific resource created by `for_each` using `each.key`. For example, you created multiple VPCs using `for_each`. To differentiate between them, we can use: `module.vpc[each.key].vpc_id`
- You can't use `count` and `for_each` together. The way to get around this is to extract the resource with `count` into its own module. An example is in the `for-each` branch
### Remote state

### Environment parity


### Import existing infra into Terraform

### Module

## Resources
- https://learn.hashicorp.com/collections/terraform/aws