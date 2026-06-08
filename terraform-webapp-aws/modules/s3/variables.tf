variable "project_name" {
  type = string
}

variable "static_assets" {
  type = map(object({
    content_type = string
    content      = string
  }))
  default = {}
}
