#!/bin/bash

echo "⚙️ Đang thiết lập server limit..."

# 1️⃣ Sửa limits.conf
LIMITS_CONF="/etc/security/limits.conf"
if ! grep -q '* soft nofile' $LIMITS_CONF; then
    echo "* soft nofile 65536" | sudo tee -a $LIMITS_CONF
fi
if ! grep -q '* hard nofile' $LIMITS_CONF; then
    echo "* hard nofile 65536" | sudo tee -a $LIMITS_CONF
fi

# 1️⃣ Sửa pam.d/common-session
PAM_LIMITS_CONF="/etc/pam.d/common-session"
if ! grep -q 'session required pam_limits.so' $PAM_LIMITS_CONF; then
    echo "session required pam_limits.so" | sudo tee -a $PAM_LIMITS_CONF
fi

# 2️⃣ Sửa sysctl.conf
SYSCTL_CONF="/etc/sysctl.conf"
sudo tee -a $SYSCTL_CONF <<EOF

# Custom tuning for high traffic file server
fs.file-max = 2097152
net.core.somaxconn = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
EOF

# 3️⃣ Áp dụng sysctl
sudo sysctl -p
