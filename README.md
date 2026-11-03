# RHEL Patching Automation

## Project Folder Structure and File Purpose

This repository contains an Ansible-based RHEL patching automation framework designed for RHEL 8 and RHEL 9 servers running on VMware and Nutanix infrastructure.

The project uses one main playbook and one reusable role. The role is divided into task files, with each file responsible for a specific operation.

---

## 1. Complete Folder Structure

```text
rhel-patching-automation/
│
├── ansible.cfg
├── requirements.yml
├── .gitignore
├── README.md
│
├── inventory/
│   ├── hosts.ini
│   │
│   └── group_vars/
│       ├── all.yml
│       ├── rhel8_servers.yml
│       ├── rhel8_vmware_servers.yml
│       ├── rhel9_vmware_servers.yml
│       └── rhel9_nutanix_servers.yml
│
├── playbooks/
│   └── patch.yml
│
└── roles/
    └── rhel_patching/
        │
        └── tasks/
            ├── main.yml
            ├── discovery.yml
            ├── precheck.yml
            ├── cyberark.yml
            ├── nagios_suppress.yml
            ├── sosreport.yml
            ├── snapshot.yml
            ├── snapshot_vmware.yml
            ├── snapshot_nutanix.yml
            ├── patch.yml
            ├── patch_rhel8.yml
            ├── patch_rhel9.yml
            ├── reboot.yml
            ├── postcheck.yml
            ├── deep_security.yml
            ├── ocs_inventory.yml
            ├── ssh_crypto.yml
            └── nagios_restore.yml
```

---

## 2. Root Directory Files

The root directory contains the main configuration and documentation files.

| File | Purpose |
|---|---|
| `ansible.cfg` | Defines Ansible configuration such as inventory location, role paths, connection timeout, and privilege escalation settings. |
| `requirements.yml` | Defines Ansible collections and roles required by the project. |
| `.gitignore` | Prevents sensitive files, temporary files, and local development artifacts from being committed to Git. |
| `README.md` | Documents the project structure and explains the purpose of each file and directory. |

---

## 3. Inventory Directory

```text
inventory/
├── hosts.ini
└── group_vars/
```

The inventory directory defines the managed servers and their configuration.

### `inventory/hosts.ini`

Contains the list of target servers.

Servers are grouped based on:

- RHEL version
- Infrastructure platform

Example groups:

```ini
[rhel8_vmware]

[rhel9_vmware]

[rhel9_nutanix]
```

**Why it is used:** Ansible needs to know which servers it should manage. Grouping the servers allows the same playbook to target different operating systems and platforms.

### `inventory/group_vars/`

Contains variables that apply to inventory groups.

These files separate server configuration from the automation logic.

| File | Purpose |
|---|---|
| `all.yml` | Defines common variables applicable to all managed servers, such as patching enablement, reboot settings, package exclusions, and connection configuration. |
| `rhel8_servers.yml` | Defines configuration specific to RHEL 8 servers. |
| `rhel8_vmware_servers.yml` | Defines configuration specific to RHEL 8 servers running on VMware. |
| `rhel9_vmware_servers.yml` | Defines configuration specific to RHEL 9 servers running on VMware. |
| `rhel9_nutanix_servers.yml` | Defines configuration specific to RHEL 9 servers running on Nutanix. |

**Why it is used:** Variables allow the automation to adapt to different server groups without modifying the core task files.

---

## 4. Playbooks Directory

```text
playbooks/
└── patch.yml
```

### `playbooks/patch.yml`

This is the main entry point for the patching automation.

It defines:

- Which inventory group to target
- Whether Ansible should gather facts automatically
- Which role should be executed

**Why it is used:** It provides a single playbook to start the complete patching workflow instead of maintaining separate playbooks for RHEL 8, RHEL 9, VMware, and Nutanix.

---

## 5. Roles Directory

```text
roles/
└── rhel_patching/
    └── tasks/
```

The roles directory contains reusable automation logic.

### `roles/rhel_patching/`

This is the main patching role.

It contains the tasks required to discover, validate, patch, and verify RHEL servers.

**Why it is used:** A role provides a reusable and organized structure for automation. It prevents the main playbook from becoming a large collection of unrelated tasks.

---

## 6. Tasks Directory

```text
roles/rhel_patching/tasks/
```

The tasks directory contains individual YAML files. Each file performs a specific operation in the patching workflow.

### Core workflow files

| File | Purpose |
|---|---|
| `main.yml` | Controls the execution order of the role. It calls the appropriate task files and manages conditional execution. |
| `discovery.yml` | Discovers the managed server's operating system version and available Python interpreter. |
| `precheck.yml` | Performs initial checks before patching, such as OS validation, filesystem checks, and DNF availability. |
| `patch.yml` | Provides a common patching task entry point if shared patching logic is required. |
| `patch_rhel8.yml` | Contains package patching logic specific to RHEL 8. |
| `patch_rhel9.yml` | Contains package patching logic specific to RHEL 9. |
| `reboot.yml` | Handles server reboot operations when required by the patching workflow. |
| `postcheck.yml` | Performs post-patching checks to verify the server's operating system and basic health. |

### Credential and monitoring files

| File | Purpose |
|---|---|
| `cyberark.yml` | Retrieves or manages credentials through the approved CyberArk integration. |
| `nagios_suppress.yml` | Suppresses or disables monitoring alerts before patching to prevent expected maintenance alerts. |
| `nagios_restore.yml` | Restores monitoring after patching so the server returns to normal monitoring. |

### Diagnostics and infrastructure files

| File | Purpose |
|---|---|
| `sosreport.yml` | Collects diagnostic information before patching for troubleshooting and support. |
| `snapshot.yml` | Selects the appropriate infrastructure snapshot workflow. |
| `snapshot_vmware.yml` | Contains VMware-specific virtual machine snapshot operations. |
| `snapshot_nutanix.yml` | Contains Nutanix-specific virtual machine snapshot operations. |

### Additional operational files

| File | Purpose |
|---|---|
| `deep_security.yml` | Handles the Deep Security agent-related operations required by the customer. |
| `ocs_inventory.yml` | Performs OCS inventory-related operations after patching. |
| `ssh_crypto.yml` | Applies approved SSH cryptographic configuration changes, if required. |

---

## 7. Why the Project Is Organized This Way

The project separates three responsibilities:

| Component | Responsibility |
|---|---|
| Inventory | Defines which servers are managed and their configuration. |
| Playbook | Defines the entry point and target hosts. |
| Role | Defines the automation workflow and operational tasks. |

The role is further divided into task files so that each operation can be maintained independently.

For example:

- OS discovery is maintained in `discovery.yml`.
- RHEL 8 patching is maintained in `patch_rhel8.yml`.
- RHEL 9 patching is maintained in `patch_rhel9.yml`.
- VMware snapshot operations are maintained in `snapshot_vmware.yml`.
- Nutanix snapshot operations are maintained in `snapshot_nutanix.yml`.

This makes the project easier to understand, maintain, troubleshoot, and extend.

---

## 8. Important Design Principle

The project follows this design:

**One inventory → One main playbook → One reusable role → Multiple task files**

The automation dynamically selects the appropriate task file based on the discovered RHEL version and the configured infrastructure platform.

This avoids creating separate automation projects for every operating system and infrastructure combination.

---

## 9. Implementation Status

The folder structure represents the planned patching workflow.

The presence of a task file does not necessarily mean the corresponding integration is fully implemented.

Customer-specific integrations such as CyberArk, Nagios, VMware snapshots, Nutanix snapshots, Deep Security, OCS inventory, and SSH cryptographic configuration require implementation and validation before production use.
