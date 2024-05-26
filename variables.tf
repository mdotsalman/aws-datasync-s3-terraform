variable "current_workspace" {}

variable "account_name" {type = string}

variable "tags" {type = map(any)}

variable "aws_profile" {}

variable "product" {type = string}

variable "region" {type = string}

variable "source_bucket" {}

variable "destination_bucket" {}

variable "source_directory" {}

variable "destination_directory" {}