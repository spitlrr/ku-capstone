packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}


variable "ssh-password" {
  type        = string
  default     = "capstone"
  sensitive   = true
  description = "temp password for packer to connect during builds"
}
# Official Rocky 9.7 Minimal ISO
source "virtualbox-iso" "rocky9" {
  vm_name          = "rocky-base-v2.1"
  output_directory = "output-rocky9"

  iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-minimal.iso"
  iso_checksum = "sha256:23a1ac1175d8ccada7195863914ef1237f584ff25f73bd53da410d5fffd882b0"

  http_content = {
    "/ks.cfg" = templatefile("${path.root}/http/ks.cfg.pkrtpl", {
      ssh_password = var.ssh-password
    })
  }
  guest_os_type = "RedHat_64"
  headless      = false

  # Boot command for RHEL 9.x
  boot_wait = "10s"
  boot_command = [
    "<wait10>",
    "<tab><wait>",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]
  # VirtualBox Guest Additions
  guest_additions_mode = "upload"
  guest_additions_path = "/tmp/VBoxGuestAdditions.iso"

  # SSH Settings for Vagrant
  ssh_username     = "vagrant"
  ssh_password     = var.ssh-password
  ssh_timeout      = "30m"
  ssh_wait_timeout = "30m"

  shutdown_command = "echo '${var.ssh-password}' | sudo -S /sbin/halt -h -p"

  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--memory", "4096"],
    ["modifyvm", "{{ .Name }}", "--cpus", "4"],
    ["modifyvm", "{{ .Name }}", "--paravirtprovider", "kvm"],
    ["modifyvm", "{{ .Name }}", "--nictype1", "82540EM"],
    ["modifyvm", "{{ .Name }}", "--ioapic", "on"],
    ["modifyvm", "{{ .Name }}", "--nested-hw-virt", "off"],
    ["modifyvm", "{{ .Name }}", "--boot1", "disk"],
    ["modifyvm", "{{ .Name }}", "--boot2", "dvd"],
    ["modifyvm", "{{ .Name }}", "--boot3", "none"],
    ["modifyvm", "{{ .Name }}", "--boot4", "none"],
    ["modifyvm", "{{ .Name }}", "--vram", "128"],
    ["modifyvm", "{{ .Name }}", "--audio", "none"]
  ]
}

build {
  sources = ["source.virtualbox-iso.rocky9"]

  # Runs the script below to install Guest Additions
  provisioner "shell" {
    script = "${path.root}/../scripts/cleanup.sh"
  }

  post-processors {
    post-processor "vagrant" {
      output = "rocky-base-v2.1.box"
    }
  }
}