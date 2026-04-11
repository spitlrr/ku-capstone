#!/usr/bin/env bash
set -e

cd vagrant
vagrant up
vagrant ssh-config > ../ansible/ssh_config
cd ..

cd ansible
ANSIBLE_CONFIG=ansible.cfg ansible all -m ping
ANSIBLE_CONFIG=ansible.cfg ansible-playbook playbooks/bootstrap.yml
cd ..