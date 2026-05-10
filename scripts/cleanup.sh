#!/bin/bash
set -euo pipefail

# 1. Install VirtualBox Guest Additions 
# (Necessary since your pkr.hcl is already uploading this)
sudo mkdir -p /mnt/virtualbox
if [ -f /tmp/VBoxGuestAdditions.iso ]; then
  # Install dependencies for Guest Additions
  sudo dnf install -y kernel-devel-$(uname -r) kernel-headers gcc make perl elfutils-libelf-devel
  sudo mount -o loop /tmp/VBoxGuestAdditions.iso /mnt/virtualbox
  sudo /mnt/virtualbox/VBoxLinuxAdditions.run || true
  sudo umount /mnt/virtualbox
  rm -f /tmp/VBoxGuestAdditions.iso
else
  echo "VBoxGuestAdditions.iso not found, skipping."
fi

# 2. Cleanup Ephemeral Keys
# Removes the temporary Packer key while leaving the standard Vagrant key intact
if [ -f /home/capstone/.ssh/authorized_keys ]; then
  sudo rm -f /home/capstone/.ssh/authorized_keys
fi

# 3. Final SSH Lockdown
sudo sed -ri 's/^\s*#?\s*PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config

sudo systemctl restart sshd

# 4. Storage Optimization
sudo dnf clean all
sudo rm -rf /var/cache/dnf


sudo journalctl --vacuum-time=1s

# 5. Zero out the drive for better Vagrant box compression
echo "Zeroing device to optimize compression (this may take a minute)..."
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sudo rm -f /EMPTY


sync