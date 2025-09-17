output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.dr_bastion.public_ip
}
output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
  description = "ARN של תעודת ה-ACM עבור drstatuspage.click"
}

output "alb_dns_name" {
  value = aws_route53_record.alb.fqdn
  description = "FQDN של ה-ALB"
}


