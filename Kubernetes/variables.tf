variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "queue_name" {
  type        = string
  description = "Queue name in Azure"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account name in Azure"
}

variable "tiemout_queue" {
  type        = number
  description = "Visibility Timeout taks in Azure"
}

