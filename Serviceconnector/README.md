Terraform code to create OCI logging loggroup and enable service logs. 

It will create service connector for source logging or streaming to Logging Analytics target. 

Option to create dynamic group and policy for service connector. 

Create OCI Log Analytics Log group. 

To execute the code create a provider.tf file with your preferred authentication. Update the terraform.tfvars with required values. 


        mv terraform.tfvars.example terraform.tfvars
        terraform init
        terraform plan
        terraform apply -auto-approve

