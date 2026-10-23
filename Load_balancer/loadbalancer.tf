#Do tarh ke loab balancer hote hai ek public aur ek internal load balancer | Standard and gateway = SKU
#Standard load balancer ka use karne ke liye humein public ip ki jarurat hoti hai isliye humne public ip create kiya hai
# Standard (Distiibate traffic to backend resources)
#Gateway (Direct traffic to network virtual appliances eg firewall pe divert kiya instead of backend resources)

resource "azurerm_lb" "web" {
  name = "${var.prefix}-lb"
  location = local.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku = "Standard" #idhar hamne standard load balancer ka use kiya hai
  #jo ip users uss web page to access karne ke liye use karegi usko ham frontend ip congiuaration kehte hai 
  frontend_ip_configuration {
    name = "public-frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
  tags = var.tags
}
#Ab users frontend ip configuration ke through load balancer ke paas aayenge aur load balancer unko backend pool me distribute karega
#in simple lang. frontend ip (common ip sabke liye) users ko kis backend pool pe jayegi to acces the web page
# Backend pool config : to basically vm ko recognize karne ke 2 tarike hai ek to by using NIC dusra IP address
#Hame NIC choose kiya hai :Agar aapko NIC ke through VM add karni hai, toh aapko alag se ek association resource use karni padti hai (jaise azurerm_network_interface_backend_address_pool_association).

#Agar aapko IP address ke through add karna hai, toh aap azurerm_lb_backend_address_pool_address resource ka use karte hain.
resource "azurerm_lb_backend_address_pool" "web" {
  name = "web-backend-pool"
  loadbalancer_id = azurerm_lb.web.id
}

#health probe : Load balancer ko pata hona chahiye ki kaunsa VM healthy hai aur kaunsa unhealthy hai, taki load balancer traffic ko sirf healthy VM pe hi route kare. Iske liye hum health probe ka use karte hain.
resource "azurerm_lb_probe" "http" {
  name = "http-probe"
  loadbalancer_id = azurerm_lb.web.id
  protocol = "Http"
  port = 80
  request_path = "/"
}
resource "azurerm_lb_rule" "http" {
  name = "http-rule"
  loadbalancer_id = azurerm_lb.web.id
  protocol = "Tcp"
  frontend_port = 8080
  backend_port = 80
  frontend_ip_configuration_name = "public-frontend"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.web.id]
  probe_id = azurerm_lb_probe.http.id
  disable_outbound_snat = true
}

#Azure load balancer is a layer 4 load balancer that distributes incoming
# traffic among healthy virtual machine instances.

# Load balancers uses a hash-based distribution algorithm. By default, it
# uses a 5-tuple (source IP, source port, destination IP, destination port,
# protocol type) hash to map traffic to available servers.

# Load balancers can either be internet-facing where it is accessible via
# public IP addresses, or internal where it is only accessible from a virtual
# network.

# Azure load balancers also support Network Address Translation (NAT)
# to route traffic between public and private IP addresses.

