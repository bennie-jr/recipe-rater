# EKS Node Groups
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.project
  node_role_arn   = var.role_node_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
  }

  ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  disk_size      = 20
  instance_types = ["t3a.xlarge"]

  tags = merge(
    var.tags
  )

  depends_on = [
    var.node_AmazonEKSWorkerNodePolicy,
    var.node_AmazonEKS_CNI_Policy,
    var.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  # service_account_role_arn = var.role_node_arn
  resolve_conflicts_on_create = "OVERWRITE"
}


resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "aws --profile bennie@rgt eks --region ${var.cluster_region} update-kubeconfig --name ${var.project}-cluster"
    }
    depends_on = [ aws_eks_cluster.this ]
}
