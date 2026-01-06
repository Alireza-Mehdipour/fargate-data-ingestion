variable "cluster_name" {
  type = string
}

variable "task_family" {
  type = string
}

variable "image_url" {
  description = "Base ECR image URL without tag"
  type        = string
}

variable "image_tag" {
  description = "Image version tag"
  type        = string
}
