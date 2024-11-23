variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "subnet_ids" {
  description = "A list of all subnet ids in all AZs"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "A list of all subnet ids in all AZs"
  type = list(string)
}

variable "role_cluster_arn" {
  description = "value"
  type = string
}

variable "role_node_arn" {
  description = "value"
  type = string
}

variable "role_node_id" {
  description = "value"
  type = string
}

variable "cluster_AmazonEKSClusterPolicy" {
  description = "value"
  type = any
}

variable "node_AmazonEKSWorkerNodePolicy" {
  description = "value"
  type = any
}

variable "node_AmazonEKS_CNI_Policy" {
  description = "value"
  type = any
}

variable "node_AmazonEC2ContainerRegistryReadOnly" {
  description = "value"
  type = any
}

variable "cluster_region" {
  description = "The region AWS cluster is being deployed in"
  type = string
}
