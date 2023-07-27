variable "second_octet" {
  description = "The second octet of the CIDR block (10.X.0.0/16) that will be used for the VPC"
  type        = string
  default     = "185"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "tplus"

}

variable "no_of_availability_zones" {
  description = "The number of availability zones to use for the VPC"
  type        = number
  default     = 3
}

