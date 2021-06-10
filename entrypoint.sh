#!/bin/sh

set -e

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

if ! whoami >/dev/null 2>&1; then
    sed -i '/^toolbox/d' /etc/passwd
    echo "toolbox:x:${USER_ID}:${GROUP_ID}::/home/toolbox:/bin/bash" >> /etc/passwd
fi

exec "$@"
