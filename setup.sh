#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Fedora Setup...${NC}"

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Ansible not found. Installing..."
    sudo dnf install -y ansible
fi

# Run the playbook
echo -e "${GREEN}Running Ansible Playbook...${NC}"
# We use -K to ask for sudo password for the 'become' tasks
ansible-playbook playbook.yml -K

echo -e "${GREEN}Setup Complete!${NC}"
