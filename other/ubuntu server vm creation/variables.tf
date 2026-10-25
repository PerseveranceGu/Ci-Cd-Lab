# eg <ip>/api2/json
variable "proxmox_api_url"      { type = string }

# the tocken id gotten when creating the terraform tocken in proxmox
variable "proxmox_token_id"     { type = string }

# the secret gotten when creating the terraform tocken in proxmox
variable "proxmox_token_secret" { 
				  type = string
				  sensitive = true 
				}

#important if we have multiple proxmox intances (or one with multple pves)
variable "proxmox_node"         { 
				  type = string
				  default = "pve"
				                 }


# the terraform tocken can not be enough to give terraform access to proxmox so bpg/proxmox (proxmox provider) falls on ssh
variable "proxmox_ssh_password" {
  type      = string
  sensitive = true
}


variable "ssh_public_key" {
  type      = string
  sensitive = true
}