
variable "region" {
  default = ""
}

variable "main_vpc_cidr" {
  default = ""
}

variable "public_subnets" {
  default = ""
}

variable "private_subnets" {
  default = ""
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type    = string
  default = ""
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "env" {
  description = "ENV NAME"
  type        = string
}

#variable "VpcCIDR" {
#  description = "CIDR block for the VPC"
#  type        = string
##  default     = ""
#}
#
#variable "PublicSubnet1CIDR" {
#  description = "CIDR block for the First public subnet"
#  type        = string
##  default     = ""
#}
#
#variable "PrivateSubnet1CIDR" {
#  description = "CIDR block for the First private subnet"
#  type        = string
##  default     = ""
#}
#
#variable "PublicSubnet2CIDR" {
#  description = "CIDR block for the Second public subnet"
#  type        = string
##  default     = ""
#}
#
#variable "PrivateSubnet2CIDR" {
#  description = "CIDR block for the Second private subnet"
#  type        = string
##  default     = ""
#}
#
#variable "GitHubOwner" {
#  description = "Name of GitHub Owner"
#  type        = string
##  default     = ""
#}
#
#variable "GitHubRepo" {
#  description = "Name of GitHub Repo"
#  type        = string
##  default     = ""
#}
#
#variable "GitHubBranch" {
#  description = "Name of GitHub Repo Branch"
#  type        = string
##  default     = ""
#}
#
#variable "GitHubOAuthToken" {
#  description = "GitHub OAuth Token"
#  type        = string
##  default     = ""
#}
#
#variable "NotificationEmail" {
#  description = "Email address where notifications will be sent"
#  type        = string
##  default     = ""
#}
#
#variable "env" {
#  description = "name of environment"
#  type        = string
#}
#
##=====================================END VARIABLES==========================
