terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.proxmox_ssh_password
  }

}


resource "proxmox_virtual_environment_vm" "stage-VM" {
  count     = 3
  name      = "stage-VM-${count.index}"
  node_name = var.proxmox_node
  clone { 
	 vm_id = 9000
	 full = true 
	}
  disk {
    datastore_id = "tank"
    interface    = "scsi0"
    size         = 32   # in GB
  }
  cpu    { cores = 2 }
  memory { dedicated = 4096 }
  initialization {

    ip_config {
      ipv4 {
        address = "dhcp"
    }
  }

    ip_config {
      ipv4 {
        address = "dhcp"
    }
  }

    user_data_file_id = proxmox_virtual_environment_file.cloudinit[count.index].id
  }
}

resource "proxmox_virtual_environment_file" "cloudinit" {
  count        = 3
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node
  source_raw {
    data = templatefile("${path.module}/cloud-init.yaml", {
      ssh_public_key = var.ssh_public_key
      hostname       = "stage-vm-${count.index}"

    })
    file_name = "stage-vm-${count.index}.yaml"
  }
}
