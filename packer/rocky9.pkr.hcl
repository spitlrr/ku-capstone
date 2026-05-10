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

# Official Rocky 9.6 Minimal ISO
source "virtualbox-iso" "rocky9" {
  vm_name          = "rocky-base-v2.1"
  output_directory = "output-rocky9"

  iso_url      = "https://dl.rockylinux.org/vault/rocky/9.6/isos/x86_64/Rocky-9.6-x86_64-minimal.iso"
  iso_checksum = "sha256:aed9449cf79eb2d1c365f4f2561f923a80451b3e8fdbf595889b4cf0ac6c58b8"

  http_content = {
    "/ks.cfg" = templatefile("${path.root}/http/ks.cfg.pkrtpl", {
      ssh_public_key = build.SSHPublicKey
    })
  }
  guest_os_type = "RedHat_64"
  headless      = false

  # Boot command for RHEL 9.x
  boot_wait = "10s"
  boot_command = [
    "<wait10>",
    "<tab><wait>",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg inst.resolution=1024x768<enter>"
  ]
  # VirtualBox Guest Additions
  guest_additions_mode = "upload"
  guest_additions_path = "/tmp/VBoxGuestAdditions.iso"

  # SSH Settings for Vagrant
  ssh_username     = "capstone"
  ssh_timeout      = "30m"
  ssh_wait_timeout = "30m"
  ssh_clear_authorized_keys = true # clean up ephemeral keys after build

  shutdown_command = "sudo /sbin/halt -h -p"

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