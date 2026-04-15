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
sed -ri 's/^\s*#?\s*PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
grep -q '^PasswordAuthentication' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
systemctl restart sshd

# clean up DNF cache and unused packages
dnf clean all
rm -rf /var/cache/dnf

# minimize logs
journalctl --vacuum-time=1s

# zero out the drive to help compression
dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY

# sync to ensure all writes are complete
sync