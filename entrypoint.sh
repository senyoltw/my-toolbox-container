#!/bin/sh

set -e

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

if ! whoami >/dev/null 2>&1; then
    sed -i '/^toolbox/d' /etc/passwd
    sed -i '/^root/d' /etc/group
    echo "toolbox:x:${USER_ID}:${GROUP_ID}::/home/toolbox:/bin/bash" >> /etc/passwd
    echo "root:x:0:0,${USER_ID}:toolbox" >> /etc/group
fi

exec "$@"
