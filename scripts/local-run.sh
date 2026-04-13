#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-all}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."&& pwd)"
PACKER_DIR="$REPO_ROOT/packer"
VAGRANT_DIR="$REPO_ROOT/vagrant"
BOX_NAME="rocky-base-v2.1"
BOX_FILE="$PACKER_DIR/rocky-base-v2.1.box"
VARS_FILE="$PACKER_DIR/local.auto.pkrvars.hcl"
check_build_vars() {
    if [[ ! -f "$VARS_FILE" ]]; then
        echo "Missing: $VARS_FILE not found. Create it from packer/local.auto.pkrvars.example.hcl first."
        exit 1
    fi
}

build_box() {
    check_build_vars
    cd "$PACKER_DIR"
    packer build ./rocky9.pkr.hcl
}

bring_up_vm() {
    if [[ ! -f "$BOX_FILE" ]]; then
        echo "Missing: $BOX_FILE." 
        echo "run build first."
        exit 1
    fi

    cd "$REPO_ROOT"
    vagrant box add --name "$BOX_NAME" --provider virtualbox $BOX_FILE --force

    cd "$VAGRANT_DIR"
    vagrant destroy -f
    vagrant up --provider=virtualbox
}

login_capstone() {
    cd "$VAGRANT_DIR"
    vagrant ssh-config > ssh_config
    ssh -t -F ssh-config default "sudo -iu capstone bash -l"
}

case "$MODE" in
    build)
        build_box
        ;;
    up)
        bring_up_vm
        ;;
    login)
        login_capstone
        ;;
    all)
        build_box
        bring_up_vm
        login_capstone
        ;;
    *)
        echo "Usage: ./scripts/run-local.sh [all|build|up|login]"
        exit 1
        ;;
esac