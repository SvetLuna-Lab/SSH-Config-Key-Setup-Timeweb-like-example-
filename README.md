# SSH Config & Key Setup (Timeweb-like example)

This mini-project shows how to configure passwordless SSH access to a remote Linux server
using `~/.ssh/config` and proper file permissions.

The example is based on a simple scenario:
you have a private/public key pair (`timeweb`, `timeweb.pub`) and want to connect to
`<ip_address_of_your_machine>` without passing `-i` on every `ssh` or `rsync` call.

## Steps

1. Create the SSH directory and set secure permissions:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
Copy your private and public keys:

bash

cp -fv timeweb timeweb.pub ~/.ssh/
chmod 600 ~/.ssh/timeweb*
Create or edit ~/.ssh/config:

bash

touch ~/.ssh/config
chmod 600 ~/.ssh/config

cat >> ~/.ssh/config << 'EOF'
Host my-timeweb
    HostName <ip_address_of_your_machine>
    User <your_remote_system_user_name>
    IdentityFile ~/.ssh/timeweb
EOF
Connect using the host alias:

bash

ssh my-timeweb
# or
ssh my-timeweb -v     # verbose log for debugging
Now you don’t need to specify the key path on each connection or in rsync.

File permissions (why 600 and 700?)
700 for ~/.ssh:

owner: read, write, execute

group: no access

others: no access

600 for private keys and config:

owner: read, write

group/others: no access

OpenSSH refuses to use keys if their permissions are too open — this is a basic
security requirement.

Contents
examples/ssh_config_example – minimal SSH config snippet with comments.

scripts/setup_ssh_config.sh – simple shell script that automates the steps above.

docs/ssh_permissions_explained.md – short explanation of UNIX permissions and why they matter for SSH.

---

## 3. Пример `examples/ssh_config_example`

```text
# ~/.ssh/config

Host my-timeweb
    HostName 203.0.113.10        # replace with your server IP
    User svetlana                # replace with your remote user
    IdentityFile ~/.ssh/timeweb
    Port 22
    # ForwardAgent no
    # PreferredAuthentications publickey
