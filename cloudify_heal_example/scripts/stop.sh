#!/bin/bash -e

# RHEL and CentOS supported only

ctx logger info "Uninstalling HAProxy"

if command -v yum > /dev/null 2>&1; then
    sudo yum remove -y haproxy policycoreutils-python
else
    ctx abort-operation "Unsupported distribution"
fi

ctx logger info "Uninstalled HAProxy"
