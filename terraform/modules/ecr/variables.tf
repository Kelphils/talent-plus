
variable "registry_name" {
  description = "The name of the registry."
  type        = string
}

variable "repository_force_delete" {
  description = "Whether to force delete the repository."
  default     = true
  type        = bool
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "type" {
  description = "The type of repository to create. Valid values are `private` and `public`."
  default     = "public"
  type        = string
}
