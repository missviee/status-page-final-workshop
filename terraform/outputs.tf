output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.dr_bastion.public_ip
}



