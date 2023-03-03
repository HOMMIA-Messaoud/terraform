variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "us-east-1"
}
variable "AWS_AMIS" {
type = map
default = {
"us-east-1" = "ami-0557a15b87f6559cf"
"eu-west-3" = "ami-05b457b541faec0ca"
}
}
variable "instance_count" {
  default = "2"
}
variable "is_prod" {
type = list(bool)
default = [false, true]
}
