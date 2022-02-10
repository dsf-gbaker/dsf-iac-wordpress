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

variable "wordpress-major-v" {
  default = "5"
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