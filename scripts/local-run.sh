#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-all}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKER_DIR="$REPO_ROOT/packer"
VAGRANT_DIR="$REPO_ROOT/vagrant"
BOX_NAME="rocky-base-v2.1"
BOX_FILE="$PACKER_DIR/rocky-base-v2.1.box"

# Removed strict check for VARS_FILE since we use ephemeral keys now
build_box() {
    echo "Starting Packer build for Rocky 9.6..."
    cd "$PACKER_DIR"
    # Added init to ensure plugins are ready
    packer init ./rocky9.pkr.hcl
    packer build ./rocky9.pkr.hcl
}

bring_up_vm() {
    if [[ ! -f "$BOX_FILE" ]]; then
        echo "Error: $BOX_FILE not found. Run build first."
        exit 1
    fi

    cd "$REPO_ROOT"
    echo "Adding box $BOX_NAME to Vagrant..."
    vagrant box add --name "$BOX_NAME" --provider virtualbox "$BOX_FILE" --force

    cd "$VAGRANT_DIR"
    echo "Deploying VM..."
    vagrant destroy -f
    vagrant up --provider=virtualbox
}

login_capstone() {
    echo "Connecting to VM as capstone..."
    cd "$VAGRANT_DIR"
    # Vagrant uses the 'vagrant' user by default. We ssh as vagrant then switch to capstone.
    vagrant ssh -c "sudo -iu capstone"
}

case "$MODE" in
    build) build_box ;;
    up)    bring_up_vm ;;
    login) login_capstone ;;
    all)
        build_box
        bring_up_vm
        login_capstone
        ;;
    *)
        echo "Usage: $0 [all|build|up|login]"
        exit 1
        ;;
esac