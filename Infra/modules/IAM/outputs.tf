# IAM Role Master's ARN
output "role_cluster_arn" {
  value = aws_iam_role.cluster.arn
}

# IAM Role Worker's ARN
output "role_node_arn" {
  value = aws_iam_role.node.arn
}

output "eks-nodes-role_id" {
  value = aws_iam_role.node.id
}

output "cluster_AmazonEKSClusterPolicy" {
  value = aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
}

output "node_AmazonEKSWorkerNodePolicy" {
  value = aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy
}

output "node_AmazonEKS_CNI_Policy" {
  value = aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy
}

output "node_AmazonEC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
}
