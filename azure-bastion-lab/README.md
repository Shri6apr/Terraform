1.Order in which the stuff will be made
-RG : Already made
-VNet : Priv network : 10.0.0.0/16
-Subnet +NSG (Separate jump box, web, app and DB tiers??)
-PIP
NIC
VM

Step 1 :Format your Terraform files
    terraform fmt -recursive

Step 2:Initialize Terraform 
    terraform init

Step 3:Validate the configuration
    terraform validate

Step 4 : Preview what Azure will create
    terraform plan -out=tfplan

Step 5 :Create the architecture
    terraform apply tfplan
Step 6:To destroy
    terraform destroy