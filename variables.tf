variable "cluster_ip" {
  description = "Kubernetes cluster IP"
}

variable "client_cert" {
  description = "Client Certificate"
}

variable "client_key" {
  description = "Client Key"
}

variable "ca_crt" {
  description = "CA Cert"
}

variable "instance_count" {
  description = "Instance count"
  default     = 1
}

variable "demo_app_label" {
  description = "Label"
  default     = "demo-app"
}

variable "demo_app_ns_name" {
  description = "Namespace name"
  default     = "demo-app-ns"
}
