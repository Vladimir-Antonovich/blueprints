#!/bin/bash -e

# RHEL and CentOS supported only

ctx logger info "Installing HAProxy"

if command -v yum > /dev/null 2>&1; then
    sudo yum install -y haproxy policycoreutils-python
    sudo semanage permissive -a haproxy_t
    sudo systemctl enable haproxy
else
    ctx abort-operation "Unsupported distribution"
fi

ctx logger info "Installed HAProxy"
