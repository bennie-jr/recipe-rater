variable "argo_namespace" {
  description = "Cluster namespace for argo cd deployment"
  type = string
}

variable "set_ingress_as_default" {
  type = bool
}