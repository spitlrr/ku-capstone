packer {
  required_plugins {
    virtualbox = {
      version = " >=1.1.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = " >=1.1.0"
      source  = "github.com/hashicorp/vagrant"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "ssh-password" {
  type        = string
  default     = "capstone"
  sensitive   = true
  description = "temp password for packer to connect during builds"
}