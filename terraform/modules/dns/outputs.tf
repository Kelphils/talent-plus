output "url" {
  value       = [for r in aws_route53_record.record : r.fqdn]
  description = "The URL of the record"
}

output "subdomain_name" {
  value       = aws_route53_zone.dns.name
  description = "The subdomain name of the service"
}
