resource "oci_core_instance" "test_instance2" {
  availability_domain        = data.oci_identity_availability_domain.ad.name
  compartment_id             = "ocid1.compartment.oc1..aaaaaaaax4radpic5dz6hwvcgz3jvk56bxmsl623gvnjzjqmcfsnib3wa22a"
  display_name               = "kk-Instance2"
  shape                      = "VM.Standard.E2.1.Micro"
  shape_config {
    ocpus = 1
    memory_in_gbs = 1
  }
  
  source_details {
    source_type = "image"
    source_id = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaazh7yy43lvzjot6q5br66wh42gdzz7ek3m5b4eokovk6re3ww77pa"
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.vcn.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "kkinstance2"
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }

  timeouts {
    create = "60m"
  }
}
