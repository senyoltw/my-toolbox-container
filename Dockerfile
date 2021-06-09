FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

USER root

ENV HOME=/home/toolbox \
    PYTHON_VERSION="3.8" \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

RUN microdnf -y install yum && \
    yum -y -q install bash tar gzip unzip which shadow-utils findutils wget curl \
    sudo git procps-ng bzip2 make podman && \
    
    yum -y -q module reset python38 && \
    yum -y -q module enable python38:${PYTHON_VERSION} && \
    yum -y -q install python38 python38-devel python38-setuptools python38-pip && \
    
    yum -y -q update && \
    yum -y -q clean all && rm -rf /var/cache/yum && \
    
    useradd -u 1001 -G wheel,root -d ${HOME} --shell /bin/bash -m toolbox && \
    mkdir -p ${HOME}/che /projects && \
    
    for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects"; do \
        chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done 
    

USER 1001
WORKDIR /projects
CMD tail -f /dev/null
