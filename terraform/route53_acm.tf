# משתמשים ב-Hosted Zone קיים (של AWS Registrar)
data "aws_route53_zone" "main" {
  name         = "drstatuspage.click"
  private_zone = false
}

# ACM Certificate עם DNS Validation
resource "aws_acm_certificate" "cert" {
  domain_name       = "drstatuspage.click"
  validation_method = "DNS"
  subject_alternative_names = ["*.drstatuspage.click"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = "dr_statuspage"
    Owner   = "dr_admin"
  }
}

# רשומות DNS לאימות ה-ACM
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# אימות ה-ACM
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# רשומת CNAME שמפנה ל-ALB
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.drstatuspage.click"
  type    = "CNAME"
  ttl     = 300
  records = ["k8s-default-drstatus-ac2719efaf-2000775354.us-east-1.elb.amazonaws.com"]
}


