#!/bin/bash
set -euo pipefail

# install VirtualBox Guest Additions (optional - may fail)
# sudo mkdir -p /mnt/virtualbox
# if [ -f /tmp/VBoxGuestAdditions.iso ]; then
#   sudo mount -o loop /tmp/VBoxGuestAdditions.iso /mnt/virtualbox || true
#   sudo /mnt/virtualbox/VBoxLinuxAdditions.run || true
#   sudo umount /mnt/virtualbox 2>/dev/null || true
#   rm -rf /tmp/VBoxGuestAdditions.iso || true
# else
#   echo "VBoxGuestAdditions.iso not found, skipping installation."
# fi

# disable password authentication
sudo sed -ri 's/^\s*#?\s*PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo grep -q '^PasswordAuthentication' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config >/dev/null
sudo systemctl restart sshd

# clean up DNF cache and unused packages
sudo dnf clean all
sudo rm -rf /var/cache/dnf

# minimize logs
sudo journalctl --vacuum-time=1s

# zero out the drive to help compression
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sudo rm -f /EMPTY

# sync to ensure all writes are complete
sync