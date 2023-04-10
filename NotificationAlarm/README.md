Terraform code to create a Topic if not existing,subscription for existing function and alarms

Create a provider.tf file based on the authentication method chosen. Please refer --> https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm

Terraform version used must be equal or greater than **1.3.0**. 

An example terraform.tfvars.example ,provider.tf.example file is provided for reference.    


    mv terraform.tfvars.example terraform.tfvars. 
    mv provider.tf.example provider.tf. 


Terraform commands to execute 

    terraform init.  
    terraform plan.  
    terraform apply -auto-approve. 
 
