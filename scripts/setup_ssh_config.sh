#!/usr/bin/env bash
set -e

KEY_NAME="timeweb"
HOST_ALIAS="my-timeweb"
HOST_IP="<ip_address_of_your_machine>"
REMOTE_USER="<your_remote_system_user_name>"

mkdir -p ~/.ssh
chmod 700 ~/.ssh

cp -fv "${KEY_NAME}" "${KEY_NAME}.pub" ~/.ssh/
chmod 600 ~/.ssh/${KEY_NAME}*

CONFIG_FILE=~/.ssh/config
touch "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# remove old block with same Host, если есть
grep -v "Host ${HOST_ALIAS}" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" || true
mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

cat >> "$CONFIG_FILE" <<EOF

Host ${HOST_ALIAS}
    HostName ${HOST_IP}
    User ${REMOTE_USER}
    IdentityFile ~/.ssh/${KEY_NAME}
EOF

echo "Done. Try: ssh ${HOST_ALIAS}"
