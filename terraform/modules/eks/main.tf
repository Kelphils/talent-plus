provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

locals {
  name   = var.eks_cluster_name
  region = data.aws_region.current.name

  cluster_version = "1.24"

  tags = {
    Blueprint = local.name
  }
}



################################################################################
# Cluster
################################################################################

#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.12"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  kms_key_users = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/SNS",
  ]
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks.name}"
      username = "${aws_iam_role.eks.name}:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/SNS"
      username = "user"
      groups   = ["system:masters"]
    },
  ]
  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    worker-node = {
      instance_types = ["t3.medium"]

      min_size          = 1
      max_size          = 2
      desired_size      = 2
      disk_size         = 20
      capacity_type     = "ON_DEMAND"
      enable_monitoring = true
      ebs_optimized     = true
      iam_role_additional_policies = {
        # Update the IAM policies here as a map of strings
        ssm_read_only             = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
        ec2_read_only             = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
        ssm_managed_instance_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }
  node_security_group_additional_rules = {

    # allow connections from ALB security group
    # ingress_allow_access_from_alb_sg = {
    #   type        = "ingress"
    #   protocol    = "-1"
    #   from_port   = 0
    #   to_port     = 0
    #   cidr_blocks = ["0.0.0.0/0"]
    #   #   source_security_group_id = var.alb_security_groups
    # }

    #  allow ssh connections from everywhere
    ingress_allow_ssh = {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
      #   source_security_group_id = var.alb_security_groups
    }

    #  allow http connections from everywhere
    ingress_allow_http = {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
      #   source_security_group_id = var.alb_security_groups
    }

    # allow connections from EKS to the internet
    # egress_all = {
    #   protocol         = "-1"
    #   from_port        = 0
    #   to_port          = 0
    #   type             = "egress"
    #   cidr_blocks      = ["0.0.0.0/0"]
    #   ipv6_cidr_blocks = ["::/0"]
    # }
    # allow connections from EKS to EKS (internal calls)
    ingress_self_all = {
      protocol  = "-1"
      from_port = 0
      to_port   = 0
      type      = "ingress"
      self      = true
    }
  }

  tags = local.tags
}


resource "aws_iam_policy" "acm_access_policy" {
  name        = "${local.name}-acm-access-policy"
  path        = "/"
  description = "Allows access to ACM"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "acm:DescribeCertificate",
          "acm:RequestCertificate",
          "acm:UpdateCertificateOptions",
          "acm:DeleteCertificate",
          "acm:AddTagsToCertificate",
          "acm:RemoveTagsFromCertificate",
          "acm:ListTagsForCertificate"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(local.tags, {
    "Name" = "${local.name}"
  })
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.name}-acm-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "acm_access_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = aws_iam_policy.acm_access_policy.arn
}

# module "aws_lb_controller" {
#   source = "./modules/aws-lb-controller"

#   #namespace        = "lb-ingress"
#   #create_namespace = true
#   enabled = true

#   cluster_identity_oidc_issuer     = module.eks.eks_cluster_identity_oidc_issuer
#   cluster_identity_oidc_issuer_arn = module.eks.eks_cluster_identity_oidc_issuer_arn
#   cluster_name                     = module.eks.eks_cluster_id

#   depends_on = [
#     module.eks
#   ]
# }

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

# create IAM role for AWS Load Balancer Controller, and attach to EKS OIDC
# module "eks_ingress_iam" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 4.22.0"

#   role_name                              = "load-balancer-controller"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks-cluster.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }


# kubectl debug node/ip-10-185-80-112.eu-north-1.compute.internal -it --image=ubuntu


# IAM Role for Eks cluster
resource "aws_iam_role" "eks" {
  name = "${var.project}-eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "eks_role_policy_attachment" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
