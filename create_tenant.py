# Python script to create a tenant on EKS cluster

import sys
import subprocess
import os
import boto3

# EKS cluster name
eks_cluster_name = "my_eks_cluster"

# Update kubeconfig using aws eks command
aws_update_kubeconfig_cmd = f"aws eks --region us-east-1 update-kubeconfig --name {eks_cluster_name}"

# Define kubernetes manifests file path
k8s_manifests_path = "manifests"

# Function to create a tenant and deploy on EKS
def deploy_to_k8s():
    deployment_yaml = os.path.join(sys.path[0], k8s_manifests_path, "deployment.yaml")
    service_yaml = os.path.join(sys.path[0], k8s_manifests_path, "service.yaml")
    kubectl_deploy_cmd = f"kubectl apply -f {deployment_yaml} -n {tenant_name}"
    kubectl_service_cmd = f"kubectl apply -f {service_yaml} -n {tenant_name}"
    terraform_init_cmd = "terraform init"
    terraform_apply_cmd = f"terraform apply --auto-approve -var tenant_name={tenant_name}"
    subprocess.call(kubectl_deploy_cmd, shell=True)
    subprocess.call(kubectl_service_cmd, shell=True)
    subprocess.call(terraform_init_cmd, shell=True)
    subprocess.call(terraform_apply_cmd, shell=True)

# Add cname record in route53 
def add_cname_record(zone_id, record_name, target_domain):
    client = boto3.client('route53')
    
    # Specify the record set details
    record_set = {
        'Name': record_name,
        'Type': 'CNAME',
        'TTL': 300,
        'ResourceRecords': [{'Value': target_domain}]
    }

    # Create the record set
    response = client.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            'Changes': [
                {
                    'Action': 'CREATE',
                    'ResourceRecordSet': record_set
                }
            ]
        }
    }
    
    print(f"CNAME record added successfully. Change ID: {response['ChangeInfo']['Id']}")

if __name__ == "__main__":
    try:
        if len(sys.argv) == 2:
            tenant_name = sys.argv[1]
            print(f"Creating tenant '{tenant_name}' in kubernetes cluster '{eks_cluster_name}'")
            deploy_to_k8s()
            
            # Replace these values with your own
            zone_id = 'Z0651719KHYDB6ICNL2Y'
            record_name = f'i_{tenant_name}.arcstone.ai'
            target_domain = 'ALB addresss'

            # Call the function to add the CNAME record
            add_cname_record(zone_id, record_name, target_domain)

            print("Tenant creation successful!")

        else:
            print("Please provide tenant name:\n python3 create_tenant.py <tenant name>")
    except Exception as e:
        print("Deployment failed", e)
