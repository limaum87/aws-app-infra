# AWS Infrastructure with Terraform

This repository contains Infrastructure as Code (IaC) to provision resources on AWS using Terraform. The project follows a modular architecture, organizing resources into reusable modules, such as VPC, EC2, ALB, NAT Gateway, and Security Groups.

## **Overview**

The goal of this project is to provision a basic AWS infrastructure, including:
- A VPC with public and private subnets.
- A NAT Gateway for internet access from private subnets.
- A Security Group configured for HTTP traffic.
- An EC2 instance running an NGINX web server.
- An Application Load Balancer (ALB) for load balancing.
- A Key Pair for SSH authentication.

## **Repository Structure**

```plaintext
.
├── modules/
│   ├── ec2/                # Module for provisioning an EC2 instance
│   ├── keypair/            # Module for creating a Key Pair
│   ├── nat_gateway/        # Module for provisioning a NAT Gateway
│   ├── security_group/     # Module for configuring Security Groups
│   ├── vpc/                # Module for creating the VPC and subnets
│   ├── alb/                # Module for creating the Application Load Balancer
├── main.tf                 # Main file connecting the modules
├── variables.tf            # Variable declarations
├── outputs.tf              # Outputs declarations
├── terraform.tfvars        # Environment-specific variable values
├── .gitignore              # Ignored files and directories
