#!/bin/bash
set -e

mkdir -p inventory/group_vars
mkdir -p playbooks
mkdir -p roles/rhel_patching/tasks

touch ansible.cfg
touch requirements.yml

touch inventory/hosts.ini
touch inventory/group_vars/all.yml
touch inventory/group_vars/rhel8_servers.yml
touch inventory/group_vars/rhel9_vmware_servers.yml
touch inventory/group_vars/rhel9_nutanix_servers.yml

touch playbooks/patch.yml

for file in \
  main \
  discovery \
  precheck \
  cyberark \
  nagios_suppress \
  sosreport \
  snapshot \
  snapshot_vmware \
  snapshot_nutanix \
  patch \
  patch_rhel8 \
  patch_rhel9 \
  reboot \
  postcheck \
  deep_security \
  ocs_inventory \
  ssh_crypto \
  nagios_restore
do
  touch "roles/rhel_patching/tasks/${file}.yml"
done

echo "Project structure created!"
