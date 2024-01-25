resource "aws_iam_role" "EKSClusterRole" {  
  name = "my-eksclusterrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonSQSFullAccess" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonSESFullAccess" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEBSCSIDriverPolicy" {
 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEC2ContainerRegistryPowerUser" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonS3FullAccess" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.EKSClusterRole.name
}


resource "aws_iam_role" "eksnoderole" {  
  name = "my-eks-node-group-nodes"
  managed_policy_arns = [aws_iam_policy.iam_policy_eks_node.arn]
  depends_on = [aws_iam_openid_connect_provider.eks_oidc]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryPowerUser" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksnoderole.name
}


resource "aws_iam_role_policy_attachment" "nodes-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksnoderole.name
}


resource "aws_iam_role_policy_attachment" "nodes-AmazonSSMPatchAssociation" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eksnoderole.name
}
