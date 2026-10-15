##File Structure 

Storage Account/
│
├── main.tf :Azure Resource Group and Storage Account resources

├── providers.tf :Terraform version requirements and Azure provider configuration 
├── variables.tf :Input variable declarations
├── terraform.tfvars : Your environment-specific values
├── outputs.tf :Values Terraform displays after deployment
├── .gitignore
└── README.md