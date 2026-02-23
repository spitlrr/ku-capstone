#!/bin/bash
set -e

# 1. Install VirtualBox Guest Additions
sudo mkdir -p /mnt/virtualbox
if [ -f /tmp/VBoxGuestAdditions.iso ]; then
    sudo mount -o loop /tmp/VBoxGuestAdditions.iso /mnt/virtualbox
    sudo /mnt/virtualbox/VBoxLinuxAdditions.run || true
    sudo umount /mnt/virtualbox
    rm -rf /tmp/VBoxGuestAdditions.iso
else
    echo "VBoxGuestAdditions.iso not found, skipping installation."
fi

# Disable password authentication for SSH
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Clean up DNF cache and unused packages
sudo dnf clean all
sudo rm -rf /var/cache/dnf

# Minimize logs
sudo journalctl --vacuum-time=1s

# Zero out the drive to help compression
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sudo rm -f /EMPTY

# Sync to ensure all writes are complete
sync