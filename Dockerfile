FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
USER root
ENV HOME=/home/toolbox

RUN microdnf -y install yum && \
    yum -y -q install bash tar gzip unzip which shadow-utils findutils wget curl \
    sudo git procps-ng bzip2 gcc make podman podman-docker && \
    
    yum -y -q install python38 python38-devel python38-setuptools python38-pip && \
    
    yum -y -q update && \
    yum -y -q clean all && rm -rf /var/cache/yum && \
    
    useradd -u 1001 -G wheel,root -d ${HOME} --shell /bin/bash -m toolbox && \
    mkdir -p ${HOME}/che /projects && \
    
    for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects" "/usr/local/bin/"; do \
        chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done && \
    echo "toolbox	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers
    

ADD entrypoint.sh ${HOME}/
RUN chmod +x ${HOME}/entrypoint.sh

USER toolbox
ENTRYPOINT ["/home/toolbox/entrypoint.sh"]
WORKDIR /projects
CMD tail -f /dev/null
