resource "arvan_iaas_abrak" "abrak" {
  region   = var.region
  flavor   = "sb1-4-2-0"
  count    = 3
  name     = "${var.abrak_name}-${count.index}"
  ssh_key  = true
  key_name = "secure"
  image {
    type = "distributions"
    name = "ubuntu/22.04"
  }
  disk_size = 25
}

data "arvan_iaas_abrak" "get_abrak_id" {
  depends_on = [
    arvan_iaas_abrak.abrak
  ]
  region = var.region
  count  = 3
  name   = "${var.abrak_name}-${count.index}"
}

output "details-abrak" {
  value = data.arvan_iaas_abrak.get_abrak_id
}

resource "arvan_iaas_subnet" "subnet-1" {
  region         = var.region
  name           = "kube-subnet"
  subnet_ip      = "192.168.0.0/28"
  enable_gateway = true
  gateway        = "192.168.0.1"
  dns_servers = [
    "178.22.122.100",
    "185.51.200.2"
  ]
  enable_dhcp = true
  dhcp {
    from = "192.168.0.2"
    to   = "192.168.0.14"
  }
}

output "subnet-details" {
  value = arvan_iaas_subnet.subnet-1
}

# resource "arvan_iaas_network_attach" "attach-network-abrak" {
#   depends_on = [
#     arvan_iaas_abrak.abrak,
#     arvan_iaas_subnet.subnet-1
#   ]

#   count = 3

#   region       = var.region
#   abrak_uuid   = data.arvan_iaas_abrak.get_abrak_id[count.index].id
#   network_uuid = arvan_iaas_subnet.subnet-1.network_uuid
# }
