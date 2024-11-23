# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-cluster"
  role_arn = var.role_cluster_arn

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags
  )

  depends_on = [
    var.cluster_AmazonEKSClusterPolicy
  ]
}


