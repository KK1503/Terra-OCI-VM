terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "6.32.0"
    }
  }
}

provider "oci" {
  config_file_profile = "DEFAULT"
}