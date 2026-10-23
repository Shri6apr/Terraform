Azure resource	: Purpose
Resource Group	Container for Azure resources
Virtual Network (VNet)	Private network
Web subnet	Hosts three web VMs
App subnet	Reserved for application servers
DB subnet	Reserved for databases
Network Security Groups	Control allowed traffic
3 NICs	Network interfaces for the web VMs
3 Linux VMs + disks	Run our websites
Standard Public IP	Public entry point
Standard Load Balancer	Distributes incoming traffic

5. Why do home networks often start with 192.168?
Because certain IPv4 ranges are reserved for private networking.
Private range	Common use
10.0.0.0/8	Enterprise and cloud networks
172.16.0.0/12	Corporate/internal networks
192.168.0.0/16	Home and small-office networks

These are defined by RFC 1918.

You can choose addresses from these ranges for your own private network, provided you plan them correctly.

For example, your home router might use 192.168.1.0/24, while another person's router uses exactly the same range. That's allowed because they're separate private networks.\

Now connect everything back to Terraform.

Suppose you're creating:
resource "azurerm_virtual_network" "main" {
  name          = "demo-vnet"
  address_space = ["10.2.0.0/16"]

  # Other required settings...
}


Who chose 10.2.0.0/16?

You did! It's a private IP range that you selected for your Azure VNet.

Then:
resource "azurerm_subnet" "web" {
  name             = "web-subnet"
  address_prefixes = ["10.2.1.0/24"]

  # Other required settings...
}


You chose a smaller part of the VNet for web servers.

When you create a NIC:
ip_configuration {
  name                          = "internal"
  subnet_id                     = azurerm_subnet.web.id
  private_ip_address_allocation = "Dynamic"
}


Azure automatically assigns an available private IP from the web subnet.

If you want a specific private IP, you can use:
ip_configuration {
  name                          = "internal"
  subnet_id                     = azurerm_subnet.web.id
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.2.1.10"
}


That address must be available and valid within the subnet.

For a public IP, you don't simply invent a globally unique address. Azure allocates one from its available public IP inventory.

Architectural components 
[ ] RG (Give the reference of the old RG that was created)
[ ] LB Public IP (See how)
[ ] Azure Standard Load Balancer(In the diag. its written Inbound NAT Rules  search what does that imply)
[ ]Virtual Network (Existing VNET pe direct karwao from the bastion file)
[ ] Web Tier Subnet (Existing wale se karo) & web nsg
[ ] 3 VM's under web tier (Use loop (ig????))
[ ] App & DB tier (Existing wale ko refer karo)
[ ]Since yha pe ek LB hai ,jo ki traffic redirect ka kaam karta hai usko test karne ke liye  ham ek web url ko reach out karenge - Iske liye Nginx VM ke saath jodna hoga taaki ko ek actual web server ki tarah act kareaur HTTP req recieve karne pe HTML page send kare jo user dekhega

What happens when a user opens the website?
1. User opens http://<LB-PUBLIC-IP>.
2. Load Balancer selects a healthy backend VM for the connection.
3. The request reaches that VM on port 80.
4. Nginx receives the HTTP request.
5. Nginx sends back an HTML page.
6. The user sees the webpage.
I wish to  achieve this result  and ye Inbound NAT rule se hoga
Web VM-1 → Hello from Server 1
Web VM-2 → Hello from Server 2
Web VM-3 → Hello from Server 3


        Load Balancing Rule	      |Inbound NAT Rule
Purpose|Distribute traffic|	Forward to a particular VM
Example	|Port 80 → 3 web VMs|	Port 5001 → VM-1 port 22
Health probe	|Required	   | Not required
Typical use|	Websites and applications	 |SSH/RDP administration

Questions : 

Chat gpt wants static ip for LB PIP , what will happen if i go with dynamic ?? -> maybe azure apne aap dekh kar ek ip assign kare 

[ ]Gpt said create new standard sku for LB and dont re-use PIP jo bastion V, ko aasign kiya tha -> Now Check ki tumne kya IP bastion ko di thi 

To -do 
[ ]  Watch video on :Azure Standard Load Balancer

  Create frontend configuration, backend pool, health probe, and load-balancing rule.

  Inbound NAT rules  and don't replace HTTP load-balancing rules(?? why).

[ ] Existing Web Subnet and Web NSG

Reuse them, but verify that HTTP traffic from the Load Balancer path is allowed. [howww??]

Your earlier web NSG focused on SSH access; it may need an HTTP rule.


Action Plan : 

Steps to creat the load balancer

· Create VNet & Subnet
. Create Backend VMs
· Create Public IP
· Create Load Balancer
· Configure Frontend IP
. Create Backend Pool
. Configure Health Probe
. Configure Load-Balancing Rule
· Configure NSG Rules
. Test Load Balancing

## Three ways to install Nginx on Azure VMs
Method	How it works	Best for
Inline custom_data	Bash script directly in vm.tf	Small learning projects
External .tftpl	Separate cloud-init configuration file	Larger, organized projects
Azure VM Extension	Azure runs a script on an existing VM	Post-deployment configuration



Resource                	Action	    kaun se file mein kya ja rha
Resource Group	Reuse	data
Existing VNet	Reuse	data
Web subnet	Reuse	data
App subnet	Reuse	data
DB subnet	Reuse	data
Existing NSGs	Reuse	data
Public IP for LB	Create	resource
Standard Load Balancer	Create	resource
Backend pool + probe + rule	Create	resource
3 NICs	Create	resource + for_each
3 Linux VMs	Create	resource + for_each
