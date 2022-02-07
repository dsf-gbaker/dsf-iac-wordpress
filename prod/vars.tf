variable "tag-owner" {
  default = "beerskunk"
  type    = string
}

variable "tag-project-name" {
  default = "dsf-wordpress"
  type    = string
}

variable "tag-environment" {
  default = "prod"
  type    = string
}

variable "ami" {
  default = "ami-00edebb01849a9623" #our wordpress ami
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "hosted-zone-id" {
  type    = string
}

variable "availability-zone" {
  default = "us-east-1b"
  type    = string
}

variable "ebs-data-size" {
  default = 40
  type    = number
}

variable "ebs-data-fstype" {
  default = "xfs"
  type    = string
}

variable "ebs-data-device-name" {
  default = "/dev/xvdf"
  type    = string
}

# Wordpress Variables
variable "wp-dbname" {
  type  = string
}

variable "wp-dbuser" {
  type  = string
}

variable "wp-dbpwd" {
  type  = string
}

variable "wp-prefix" {
  type  = string
}