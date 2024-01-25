resource "aws_eks_cluster" "eks-cluster" {
  name     = "my_eks_cluster"
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = "1.27"

  vpc_config {
    subnet_ids              = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] 
    endpoint_private_access = true
    endpoint_public_access  = true    
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonSQSFullAccess,
    aws_iam_role_policy_attachment.cluster-AmazonSESFullAccess,
    aws_iam_role_policy_attachment.cluster-AmazonEBSCSIDriverPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryPowerUser
  ]
}

data "aws_security_group" "selected_main_sg" { 
  id = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id  
}

data "tls_certificate" "eks_tls_certificate" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks_tls_certificate.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks_tls_certificate.url
}

