variable "token" {
  description = "yandex IAM token"
  type        = string
  sensitive   = true
}

variable "zone" {
    type        = string
    default     = "ru-central1-a"
    description = "zone"
}

variable "cloud_id" {
  type        = string
  default     = "b1g16ug1hobhh845kp4d"
  description = "yc_cloud_id"
}

variable "folder_id" {
  type        = string
  default     = "b1g2doptj6avpp6u7oeb"
  description = "yc_folder_id"
}