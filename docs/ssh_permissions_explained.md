# SSH File Permissions Explained

When configuring SSH, correct file permissions are not just “good practice” –  
OpenSSH **refuses to use** keys and configs if they are too open.

This short note explains why we use:

- `700` for the `~/.ssh` directory
- `600` for private keys and the `config` file

and what these numbers actually mean.

---

## 1. Unix permission model: rwx and octal notation

Each file and directory in Unix-like systems has permissions for three groups:

- **user** (owner)
- **group**
- **others**

For each group there are three basic flags:

- `r` – read  
- `w` – write  
- `x` – execute (or “enter” for directories)

In symbolic form you see something like:

```text
drwx------  2 user user 4096 Jan  1 12:00 .ssh
-rw-------  1 user user  600 Jan  1 12:00 id_rsa
The same permissions can be written as an octal number:

r = 4

w = 2

x = 1

So:

rwx = 4 + 2 + 1 = 7

rw- = 4 + 2 + 0 = 6

r-- = 4 + 0 + 0 = 4

--- = 0 + 0 + 0 = 0

The octal notation has three digits: XYZ

X – for user

Y – for group

Z – for others

For example:

700 → user: rwx, group: ---, others: ---

600 → user: rw-, group: ---, others: ---

2. Why ~/.ssh must be 700
The .ssh directory contains sensitive data:

private keys

config files

known_hosts

If other users on the system can read or traverse this directory, it becomes easier to:

discover which hosts you connect to,

attempt to read or replace your keys (depending on permissions).

That is why we use:

bash

chmod 700 ~/.ssh
This means:

user: rwx – full access (read/write/enter)

group: --- – no access

others: --- – no access

Only the owner can look inside ~/.ssh and use its contents.

3. Why private keys and config must be 600
The private key (e.g. ~/.ssh/timeweb) must be:

readable and writable only by the owner,

not accessible to group or others at all.

That is why we use:

bash

chmod 600 ~/.ssh/timeweb
chmod 600 ~/.ssh/config
This means:

user: rw- – can read and modify the file

group: --- – no access

others: --- – no access

OpenSSH intentionally checks that your private key is not world-readable.
If the file is too open (for example 644 or 664), SSH can reject it with warnings like:

text

Bad permissions: ignore key: /home/user/.ssh/id_rsa
Permissions 0644 for '/home/user/.ssh/id_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This is a built-in safety mechanism to prevent obvious security mistakes.

4. Summary of recommended permissions
Typical secure setup for SSH on a single-user system:

bash

# SSH directory: owner only
chmod 700 ~/.ssh

# Private keys: owner read/write
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/timeweb

# SSH config: owner read/write
chmod 600 ~/.ssh/config

# Public keys can be more open (not secret), but 644 is common
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/timeweb.pub
700 for directories that contain sensitive SSH data

600 for private keys and config

644 is acceptable for public keys (they are not secret)

With this setup:

SSH can safely use your keys and config,

other users on the system cannot read or modify them,

and you avoid typical “Bad permissions” errors.

makefile

::contentReference[oaicite:0]{index=0}
