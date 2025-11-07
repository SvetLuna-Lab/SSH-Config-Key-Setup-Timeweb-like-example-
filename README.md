# SSH Config & Key Setup (Timeweb-like example)

This mini-project shows how to configure passwordless SSH access to a remote Linux server
using `~/.ssh/config`, secure file permissions and a small automation script.

The example is inspired by a typical VPS scenario (e.g. Timeweb), where you have a private/public
key pair and want to connect to a host without specifying `-i` on every `ssh` or `rsync` call.

---

## Overview

The repository demonstrates:

- creation of the `~/.ssh` directory with secure permissions;
- copying and protecting private/public keys;
- configuring `~/.ssh/config` with a host alias and `IdentityFile`;
- using `ssh my-timeweb` instead of a long `ssh -i path/to/key user@ip` command;
- explaining why `700` / `600` permissions are required by OpenSSH.

It can be used as:

- a personal **cheatsheet** for SSH setup;
- an **onboarding snippet** for new team members;
- a small DevOps-style portfolio example.

---

## Repository structure

```text
docs/
  ssh_permissions_explained.md   # explanation of Unix permissions and SSH security

examples/
  ssh_config_example             # sample ~/.ssh/config fragment with comments

scripts/
  setup_ssh_config.sh            # automation script to create/update SSH config

README.md                        # this file

Quick start

⚠️ Replace placeholders (<ip>, <user>, key name) with your real values
before running any commands.

Generate or obtain your key pair (if you don’t have one yet):

ssh-keygen -t ed25519 -f timeweb
# or reuse an existing key pair


Copy keys into ~/.ssh with secure permissions:

mkdir -p ~/.ssh
chmod 700 ~/.ssh

cp -fv timeweb timeweb.pub ~/.ssh/
chmod 600 ~/.ssh/timeweb*


Create or update ~/.ssh/config manually
(see examples/ssh_config_example):

touch ~/.ssh/config
chmod 600 ~/.ssh/config

cat >> ~/.ssh/config << 'EOF'
Host my-timeweb
    HostName <ip_address_of_your_machine>
    User <your_remote_system_user_name>
    IdentityFile ~/.ssh/timeweb
EOF


Connect using the host alias:

ssh my-timeweb
# or verbose mode for debugging:
ssh my-timeweb -v


Now you no longer need to specify the key path on each connection or in rsync.

Using the automation script

The repository also contains a small helper script:

scripts/setup_ssh_config.sh


It:

ensures ~/.ssh exists and has 700 permissions;

copies timeweb / timeweb.pub into ~/.ssh/ with 600 permissions;

appends a Host block to ~/.ssh/config.

Before running, edit the variables at the top of the script:

KEY_NAME="timeweb"
HOST_ALIAS="my-timeweb"
HOST_IP="<ip_address_of_your_machine>"
REMOTE_USER="<your_remote_system_user_name>"


Then:

bash scripts/setup_ssh_config.sh
ssh my-timeweb

File permissions and security

A detailed explanation is provided in:

docs/ssh_permissions_explained.md

Short version:

chmod 700 ~/.ssh — only the owner can access the directory;

chmod 600 ~/.ssh/timeweb ~/.ssh/config — only the owner can read/write these files;

OpenSSH will refuse to use keys that are world-readable (e.g. 0644), and will show
“Bad permissions” warnings.

Requirements

Linux or any Unix-like system with:

OpenSSH client (ssh, ssh-keygen),

standard shell tools (bash, mkdir, chmod, cp, cat).

No additional libraries or packages are required.

Possible extensions

This example can be extended with:

multiple host aliases (staging, production, jump host);

ProxyJump / ProxyCommand settings;

Match blocks with per-user / per-host rules.

For this mini-project, the scope is intentionally small and focused on basic, secure SSH setup.
