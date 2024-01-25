# Python script to create EKS cluster in AWS cloud
import subprocess
import os
import sys

# Terraform validate command
terraform_validate_cmd = "cd terraform_files && terraform validate"

# Terraform init command
terraform_init_cmd = "cd terraform_files && terraform init"

# Terraform apply command
terraform_apply_cmd = "cd terraform_files && terraform apply --auto-approve"

def main():
    # Execute terraform validate, init and apply
    subprocess.call(terraform_validate_cmd, shell=True)
    subprocess.call(terraform_init_cmd, shell=True)
    subprocess.call(terraform_apply_cmd, shell=True)

if __name__ == "__main__":
    main()
