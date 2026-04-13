#!/usr/bin/env bash
set -e

# from repo root run ./scripts/bootstrap-ansible.sh
cd vagrant
vagrant up
vagrant ssh-config > ../ansible/ssh-config
cd ..

cd ansible
ANSIBLE_CONFIG=ansible.cfg ansible all -m ping
ANSIBLE_CONFIG=ansible.cfg ansible-playbook playbooks/bootstrap.yml
cd ..