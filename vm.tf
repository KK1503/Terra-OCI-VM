resource "oci_core_vcn" "vcn" {
  cidr_blocks    = ["10.0.0.0/16"]
  dns_label      = "vcn"
  compartment_id = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  display_name   = "deep-vcn"
}

resource "oci_core_subnet" "vcn" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "kkSubnet"
  dns_label         = "regionalsubnet"
  compartment_id    = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  vcn_id            =  oci_core_vcn.vcn.id
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  ad_number      = 1
}

resource "oci_core_instance" "test_instance" {
  availability_domain        = data.oci_identity_availability_domain.ad.name
  compartment_id             = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  display_name               = "kk-Instance"
  shape                      = "VM.Standard.E2.1.Micro"
  shape_config {
    ocpus = 1
    memory_in_gbs = 1
  }
  
  source_details {
    source_type = "image"
    source_id = "ocid1.image.oc1.af-johannesburg-1.aaaaaaaajgtw6w4fgzpumoxil34j3z7iuhfzsmohw75sc6shdhxxm3qix54q"
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.vcn.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "kkinstance"
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }

  timeouts {
    create = "60m"
  }
}


resource "oci_core_network_security_group" "test_network_security_group" {
    #Required
    compartment_id = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
    vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule" {
    #Required
    network_security_group_id = oci_core_network_security_group.test_network_security_group.id
    direction = "INGRESS"
    protocol = 6
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
        destination_port_range {
            max = 22
            min = 22
        }
    }
    
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  display_name   = "TestInternetGateway"
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}
