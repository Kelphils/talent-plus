data "aws_caller_identity" "current" {}

# get (externally configured) DNS Zone
# ATTENTION: if you don't have a Route53 Zone already, replace this data by a new resource
locals {
  domain               = var.is_private_zone ? join(".", ["internal", var.domain_name]) : var.domain_name
  complete_domain_name = var.subdomain != "" ? join(".", [var.subdomain, var.domain_name]) : var.domain_name
}


data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "dev-ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.complete_domain_name
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.dns.name_servers
}

resource "aws_route53_zone" "dns" {
  name          = local.complete_domain_name
  force_destroy = true
  tags = {
    Projectname = var.project
  }
}

# create AWS-issued SSL certificate
resource "aws_acm_certificate" "certificate" {
  depends_on                = [aws_route53_record.dev-ns]
  domain_name               = aws_route53_zone.dns.name
  subject_alternative_names = ["*.${aws_route53_zone.dns.name}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.project}-eks-domain-cert"
  }
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.dns.zone_id
}

# comment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert_validation" {
  #
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}

# deploy Ingress Controller
# resource "kubernetes_service_account" "load_balancer_controller" {
#   metadata {
#     name      = var.ingress_gateway_name
#     namespace = "kube-system"

#     labels = {
#       "app.kubernetes.io/component" = "controller"
#       "app.kubernetes.io/name"      = var.ingress_gateway_name
#     }

#     annotations = {
#       "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ingress_gateway_iam_role}"
#     }
#   }
# }

# resource "helm_release" "ingress_gateway" {
#   name       = var.ingress_gateway_chart_name
#   chart      = var.ingress_gateway_chart_name
#   repository = var.ingress_gateway_chart_repo
#   version    = var.ingress_gateway_chart_version
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = kubernetes_service_account.load_balancer_controller.metadata.0.name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }
# }

