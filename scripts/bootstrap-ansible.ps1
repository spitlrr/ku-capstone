$ErrorActionPreference = "Stop"

Push-Location vagrant
vagrant up
vagrant ssh-config > ../ansible/ssh_config
Pop-Location

Push-Location ansible
$env:ANSIBLE_CONFIG = (Join-Path $PWD "ansible.cfg")
ansible all -m ping
ansible-playbook playbooks/bootstrap.yml
Pop-Location