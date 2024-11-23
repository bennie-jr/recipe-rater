# resource "aws_iam_role_policy" "node-group-AmazonEKS_EBS_CSI_DriverPolicy" {
#   name = "AmazonEKS_EBS_CSI_Driver_Policy"
#   role = var.role_node_id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#             "ec2:AttachVolume",
#             "ec2:CreateSnapshot",
#             "ec2:CreateTags",
#             "ec2:CreateVolume",
#             "ec2:DeleteSnapshot",
#             "ec2:DeleteTags",
#             "ec2:DeleteVolume",
#             "ec2:DescribeAvailabilityZones",
#             "ec2:DescribeInstances",
#             "ec2:DescribeSnapshots",
#             "ec2:DescribeTags",
#             "ec2:DescribeVolumes",
#             "ec2:DescribeVolumesModifications",
#             "ec2:DetachVolume",
#             "ec2:ModifyVolume"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "ebs-csi-controller" {
#   name = "ebs-csi-controller"

#   assume_role_policy = jsonencode({
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Principal": {
#                     "Federated": aws_iam_openid_connect_provider.eks.arn
#                 },
#                 "Action": "sts:AssumeRoleWithWebIdentity",
#                 "Condition": {
#                     "StringEquals": {
#                         "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#                     }
#                 }
#             }
#         ]
#     })
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_EBS_CSI_DriverPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#   role = aws_iam_role.ebs-csi-controller.name
# }



# resource "aws_eks_addon" "ebs-csi" {
#   cluster_name             = "${var.project}-cluster"
#   addon_name               = "aws-ebs-csi-driver"
#   service_account_role_arn = aws_iam_role.ebs-csi-controller.arn
#   resolve_conflicts_on_create = "OVERWRITE"
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }




data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.csi.json
  name               = "eks-ebs-csi-driver"
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.25.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
}

# resource "aws_eks_addon" "cni" {
#   cluster_name = aws_eks_cluster.this.name
#   addon_name   = "vpc-cni"
#   service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
#   resolve_conflicts_on_create = "OVERWRITE"
# }

# resource "aws_eks_addon" "kube_proxy" {
#   cluster_name      = aws_eks_cluster.this.name
#   addon_name        = "kube-proxy"
#   service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
#   resolve_conflicts_on_create = "OVERWRITE"
# }