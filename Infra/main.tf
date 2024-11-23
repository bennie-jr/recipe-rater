module "EKS" {
    source = "./modules/EKS"
    project = var.project
    cluster_region = var.cluster_region
    tags = var.tags
    private_subnet_ids = module.VPC.private_subnet_ids
    subnet_ids = module.VPC.subnet_ids
    role_cluster_arn = module.IAM.role_cluster_arn
    role_node_arn = module.IAM.role_node_arn
    role_node_id = module.IAM.eks-nodes-role_id
    cluster_AmazonEKSClusterPolicy = module.IAM.cluster_AmazonEKSClusterPolicy
    node_AmazonEKSWorkerNodePolicy = module.IAM.node_AmazonEKSWorkerNodePolicy
    node_AmazonEKS_CNI_Policy =  module.IAM.node_AmazonEKS_CNI_Policy
    node_AmazonEC2ContainerRegistryReadOnly = module.IAM.node_AmazonEC2ContainerRegistryReadOnly
}

module "VPC" {
    source = "./modules/VPC"
    project = var.project
    vpc_cidr = var.vpc_cidr
    region = var.region
    subnet_cidr_bits = var.subnet_cidr_bits
    tags =  var.tags
    availability_zones_count = var.availability_zones_count
}

module "Helm" {
    source = "./modules/Helm"
    set_ingress_as_default = var.set_ingress_as_default
    argo_namespace =  var.argo_namespace
}

module "IAM" {
    source = "./modules/IAM"
    project = var.project
}

module "Security-groups" {
    source = "./modules/Security-groups"
    project = var.project
    tags = var.tags
    vpc_id = module.VPC.vpc_id
}