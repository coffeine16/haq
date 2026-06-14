output "ec2_public_ip" {
  description = "Public IP of the Haq EC2 instance"
  value       = aws_eip.haq.public_ip
}

output "n8n_url" {
  description = "n8n editor URL (HTTP). After DuckDNS+Caddy setup, use https://<your-subdomain>.duckdns.org"
  value       = "http://${aws_eip.haq.public_ip}:5678"
}

output "ssh_command" {
  description = "SSH into the server"
  value       = "ssh -i haq-key.pem ubuntu@${aws_eip.haq.public_ip}"
}
