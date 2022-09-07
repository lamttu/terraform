provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      hashicorp-learn = "learn-terraform-aws-dynamodb-scale"
      uuid = "oheggkHn9Z6odch4Pa6yPY"
    }
  }
}

resource "random_pet" "table_name" {
  prefix    = "environment"
  separator = "_"
  length    = 4
}

resource "aws_dynamodb_table" "environment" {
  name         = random_pet.table_name.id
  billing_mode = "PROVISIONED"
  table_class  = "STANDARD_INFREQUENT_ACCESS"

  read_capacity = var.env_table_read_capacity
  write_capacity = var.env_table_write_capacity
  
  # Specify the attribute we use as TTL
  ttl {
    enabled        = true
    attribute_name = "expiry"
  }

  # Enable streaming for global tables
  # In our case, even though the main table is in us-east-1
  # We are replicating the data to us-west-1 and ap-northeast-1 defined in the tfvars file
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # This dynamic block loops through `replica_regions` array and create 1 `replica` block for each value
  # It translates to:
  # 
  # replica {
  #   region_name = "us-west-1"
  # }

  # replica {
  #   region_name = "ap-northeast-1"
  # }
  dynamic "replica" {
    for_each = var.replica_regions
    iterator = replica_region

    content {
      region_name = replica_region.value
    }
  }

  hash_key  = "deviceId"
  range_key = "epochS"

  attribute {
    name = "deviceId"
    type = "S"
  }

  attribute {
    name = "epochS"
    type = "N"
  }

  attribute {
    name = "eventId"
    type = "S"
  }
  
  attribute {
    name = "geoLocation"
    type = "S"
  }

  local_secondary_index {
    name            = "by_eventId"
    range_key       = "eventId"
    projection_type = "ALL"
  }

  global_secondary_index {
    name               = "by_geoLocation"
    hash_key           = "geoLocation"
    range_key          = "epochS"
    write_capacity     = 5
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["userId", "location"]
  }
  # When we turn on autoscaling, the read and write capacity will change 
  # So we need this lifecycle block to tell Terraform to ignore those changes
  # Otherwise, Terraform will tell us that these values have changed every time we deploy and revert them back, basically undo autoscaling 
  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}
