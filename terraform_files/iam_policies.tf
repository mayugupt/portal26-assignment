resource "aws_iam_policy" "iam_policy_eks_node" {
  name        = "my-eks-role-policy"

 policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeTags",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource": ["*"]
        },
        {
        "Effect": "Allow",
        "Action": [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "ec2:DescribeImages",
            "ec2:GetInstanceTypesFromInstanceRequirements",
            "eks:DescribeNodegroup"
        ],
        "Resource": ["*"]
        },
       {
            "Effect": "Allow",
            "Action": [
                "ssm:*",
                "ec2:describeInstances",
                "iam:ListRoles"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ssm.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
            "ec2:CreateVolume"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
            "ec2:CreateVolume"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/CSIVolumeName": "*"
                }
            }
        },
         {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:*",
                "ses:*"                
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

