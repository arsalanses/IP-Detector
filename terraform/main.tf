resource "arvan_iaas_abrak" "abrak-1" {
  region = var.region
  flavor = "g1-1-1-0"
  name   = "${var.abrak_name}-1"
  image {
    type = "distributions"
    name = "debian/12"
  }
  disk_size = 25
}

resource "arvan_iaas_abrak" "abrak-2" {
  region = var.region
  flavor = "g1-1-1-0"
  name   = "${var.abrak_name}-2"
  image {
    type = "distributions"
    name = "debian/12"
  }
  disk_size = 25
}

resource "arvan_iaas_abrak" "abrak-3" {
  region = var.region
  flavor = "g1-1-1-0"
  name   = "${var.abrak_name}-3"
  image {
    type = "distributions"
    name = "debian/12"
  }
  disk_size = 25
}

data "arvan_iaas_abrak" "get_abrak_id_1" {
  depends_on = [
    arvan_iaas_abrak.abrak-1
  ]
  region = var.region
  name   = "${var.abrak_name}-1"
}

data "arvan_iaas_abrak" "get_abrak_id_2" {
  depends_on = [
    arvan_iaas_abrak.abrak-2
  ]
  region = var.region
  name   = "${var.abrak_name}-2"
}

data "arvan_iaas_abrak" "get_abrak_id_3" {
  depends_on = [
    arvan_iaas_abrak.abrak-3
  ]
  region = var.region
  name   = "${var.abrak_name}-3"
}

output "details-abrak-1" {
  value = [
    data.arvan_iaas_abrak.get_abrak_id_1,
    data.arvan_iaas_abrak.get_abrak_id_2,
    data.arvan_iaas_abrak.get_abrak_id_3
  ]
}
