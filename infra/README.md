# Haq — Infrastructure (Terraform)

Provisions an AWS EC2 `t3.small` in `ap-south-1` (Mumbai) with VPC, public subnet, security group, key pair, and Elastic IP. Bootstraps Docker via `user-data.sh`.

## Prerequisites
- Terraform >= 1.5
- AWS CLI configured (`aws configure`) with credentials that can create EC2/VPC resources

## Deploy
```bash
cd infra
terraform init
terraform apply       # type "yes" when prompted
```

Outputs include `ec2_public_ip`, `n8n_url`, `ssh_command`. The SSH private key is written to `infra/haq-key.pem` (gitignored — never commit).

## SSH into the server
```bash
ssh -i haq-key.pem ubuntu@<ec2_public_ip>
```

## Tear down
```bash
terraform destroy
```

## Notes
- `t3.small` (2 GB RAM) is chosen because the smaller `t3.micro` (1 GB) cannot hold n8n + PDF service + Docker daemon together at startup.
- Open ports: 22 (SSH), 80/443 (Caddy HTTPS), 5678 (n8n), 3200 (PDF service).
- After deploy, follow `../server/README.md` to bring up the application stack.
