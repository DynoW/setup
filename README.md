# Automated System Setup with Ansible

Automate setup of a fresh Fedora Workstation install with Ansible: apps, dotfiles, GNOME tweaks, shell tooling, and core repos, all reproducibly from a single playbook.

## Prerequisites
- Linux host with internet access
- Python 3 and Ansible installed
- SSH keys set up if targeting remote hosts

Install Ansible:
```bash
sudo dnf install ansible
```

## Quick Start
Run the full setup on `localhost`:
```bash
./setup.sh
```

Alternatively, run the playbook manually:
```bash
ansible-playbook -i inventory.ini playbook.yml -K
```

## Inventory
Define your targets in `inventory.ini`. Example:
```ini
[local]
localhost ansible_connection=local

[workstations]
myhost ansible_host=192.168.1.50
```

Use `-l` to limit to a group or host:
```bash
ansible-playbook -i inventory.ini playbook.yml -l local
```

## Playbook & Roles
The main playbook `playbook.yml` orchestrates role tasks:

- `roles/apps`: Install and configure user applications.
	- `tasks/main.yml`
- `roles/core`: Core system setup and repositories.
	- `tasks/main.yml`, `tasks/repos.yml`, `tasks/mount-partition.yml`
	- `handlers/main.yml`
- `roles/dotfiles`: Deploy and link dotfiles.
	- `tasks/main.yml`, `tasks/firefox.yml`, `tasks/grub.yml`
	- `handlers/main.yml`
- `roles/gnome`: GNOME environment customization.
	- `tasks/main.yml`, `tasks/images.yml`, `tasks/language.yml`, `tasks/shortcuts.yml`
	- `handlers/main.yml`
- `roles/shell`: Shell configuration and Git setup.
	- `tasks/main.yml`, `tasks/git.yml`

Run specific roles via tags (ensure roles/tasks define tags accordingly):
```bash
ansible-playbook -i inventory.ini playbook.yml --tags apps
ansible-playbook -i inventory.ini playbook.yml --tags core
```

## Configuration
- Adjust `ansible.cfg` for forks, host_key_checking, and roles path if needed.
- Customize variables via group_vars/host_vars (add these directories if not present).
- Edit role task files under `roles/**/tasks/*.yml` to fit your preferences.

## Troubleshooting
- If sudo prompts hang, add `become: true` and configure `become_method` in `playbook.yml` or role tasks.
- For permission issues, verify your user is in sudoers without a TTY requirement, or run with `-K` to prompt for sudo password.
- Run with higher verbosity:
	```bash
	ansible-playbook -i inventory.ini playbook.yml -vv
	```
- Ensure `inventory.ini` points to reachable hosts; test with:
	```bash
	ansible -i inventory.ini all -m ping
	```
- Use `--step` to confirm each task interactively:
	```bash
	ansible-playbook -i inventory.ini playbook.yml --step
	```

## Uninstall / Revert
This project focuses on setup. Reverts are role-specific; review the corresponding role tasks to write an inverse playbook if needed (e.g., remove packages, unlink dotfiles, revert GNOME settings).

## License
This repository’s configuration is intended for personal/workstation setup. If you reuse parts, ensure compliance with any upstream licenses for referenced assets or dotfiles.
