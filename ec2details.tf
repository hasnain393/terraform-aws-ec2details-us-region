variable "aws_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-1", "us-west-2", "us-east-2"]  # Add more regions as needed
}

provider "aws" {
  alias = "regions"
}

data "aws_instances" "ec2_instances" {
  for_each = toset(var.aws_regions)

  instance_tags = {
    "Name" = "*"
  }
  
  instance_state_names = ["running"]

  provider = aws.regions(each.value)
  
output "ec2_instance_details" {
  value = {
    for region, instances in data.aws_instances.ec2_instances : region => instances[*].tags
  }
}
