resource "arvan_iaas_abrak" "abrak" {
  region = var.region
  flavor = "g1-1-1-0"
  count  = 3
  name   = "${var.abrak_name}-${count.index}"
  image {
    type = "distributions"
    name = "debian/12"
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
  value = [
    data.arvan_iaas_abrak.get_abrak_id
  ]
}
