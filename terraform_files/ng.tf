resource "aws_eks_node_group" "mynodegroup" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "My-NodeGroup"
  node_role_arn   = aws_iam_role.eksnoderole.arn

  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "workers"
    "alpha.eksctl.io/nodegroup-name" = "My-NodeGroup"
    "alpha.eksctl.io/cluster-name" = "my-cluster"
  }

  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/my_eks_cluster" = "owned"
  }

   launch_template {
     name    = aws_launch_template.eks-with-disks.name
     version = aws_launch_template.eks-with-disks.latest_version
   }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,  
    aws_iam_role_policy_attachment.nodes-AmazonSSMManagedInstanceCore,   
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryPowerUser,
    aws_iam_role_policy_attachment.nodes-AmazonSSMPatchAssociation,
    aws_iam_role_policy_attachment.nodes-AmazonEBSCSIDriverPolicy
  ]
}

resource "aws_launch_template" "eks-with-disks" {
   name = "my-eks-with-disks"
   block_device_mappings {
     device_name = "/dev/xvda"

     ebs {
       volume_size = 50
       volume_type = "gp3"
     }
   }
}
