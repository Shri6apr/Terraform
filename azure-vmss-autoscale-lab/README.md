# Azure Standard Load Balancer + VMSS Autoscale Lab

## Existing dependencies
This project **reads**, but does not create or modify, `rg-storage-acc`, `bastion-demo-vnet`, and `web-tier-subnet`. Existing Bastion access, app and DB subnets are outside this project's Terraform state.

## Creates
Standard static Public IP, Standard Load Balancer, backend pool, TCP port 80 probe, TCP port 80 rule, Linux VMSS with Nginx bootstrap, Azure Monitor CPU autoscale (min 1 / default 2 / max 3).

## Important prerequisites
1. Verify RG, VNet and web subnet actually exist in Azure. Check that a web-subnet NSG allows inbound TCP 80 from clients and inbound TCP 80 from the `AzureLoadBalancer` service tag for the health probe. Change rules in the **original Bastion Terraform project** if that project owns the NSG. Do not manage the same rules in two independent Terraform states.
2. VMSS instances must have outbound internet connectivity to run `apt-get install nginx` and fetch package updates. **A Standard public Load Balancer is not automatic outbound connectivity.** Provide a NAT Gateway on the subnet (preferably in the original network project), a suitable firewall/outbound route, or a prebuilt image with Nginx installed. This project deliberately does not attach a NAT Gateway to a shared subnet.
3. Confirm chosen VM size is available in the RG region, Azure resource providers are registered, quota and subscription charges are acceptable. VMSS, public IP and load balancing incur costs.
4. SSH access to VMSS instances requires working Bastion-host network routing/NSG permissions; this project adds no inbound SSH NAT rules or VM public IPs.
5. Avoid deploying this project alongside an older Load Balancer lab with overlapping VM names or conflicting NSG ownership. Use distinct prefix.

## Deploy
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
# inspect before running terraform apply tfplan
```

## Verify
```powershell
terraform output website_url
az vmss list-instances -g rg-storage-acc -n vmss-demo-web-vmss -o table
```
Initial Nginx setup may take several minutes. TCP health probe checks port 80, not HTTP content. Different requests may hit the same VM because Azure Load Balancer uses flow hashing.

## Autoscale
Azure Monitor increases instances by 1 after average CPU >70% for 5 min, decreases by 1 after <30% for 10 min, bounded 1–3. `ignore_changes = [instances]` avoids Terraform resetting autoscale-driven instance counts. Default count is 2. Autoscale is not an instant reaction to HTTP traffic and may not trigger in an idle lab.

## Clean up
```powershell
terraform destroy
```
This removes resources owned by this project, not the existing RG/VNet/subnets or Bastion VM. Review plan before destroying.
