#!/bin/bash
##############################################################################################################################
# Funktionen
##############################################################################################################################
function add_user {
  if ! id "$USER" &>/dev/null; then
    sh -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
    adduser \
    --shell /bin/bash \
    --disabled-password \
    --gecos "" \
    --home "/home/$USER" \
    --uid "$UID" \
    "$USER"
    echo "$USER:*" | chpasswd 2>> /dev/null
    adduser "$UID" "$GID"  2>> /dev/null
  fi
}

function check_to_run_teleport {
	if [ -f "/etc/teleport.yaml" ]; then
    teleport start --config=/etc/teleport.yaml &
	fi
}

function install_and_run_code_server {
  if [ ! -f "/usr/bin/code-server" ]; then
    curl -fsSL https://code-server.dev/install.sh | sh
  fi

  code-server start --user-data-dir /data/settings --config /data/config.yaml --bind-addr 0.0.0.0:8080 --auth none /home/code/ &
}

add_user
install_and_run_code_server
check_to_run_teleport

exec /usr/sbin/sshd -D -e "$@" #2> /var/log/sshd.log