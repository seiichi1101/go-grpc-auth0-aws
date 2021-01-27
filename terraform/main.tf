# Terraform Setting
terraform {
  required_version = ">= 0.13"
}

# Provider
provider "aws" {
  region = var.region
}

# Variables
variable "aws_account_id" {}

variable "domain" {}

variable "sub_domain" {
  description = "サブドメイン名"
  type        = string
  default     = "go-grpc-server"
}

variable "system_name" {
  description = "システム名"
  type        = string
  default     = "go-grpc-server"
}

variable "aws_env" {
  description = "環境名"
  type        = string
  default     = "test"
}

variable "region" {
  description = "リージョン名"
  type        = string
  default     = "ap-northeast-1"
}

