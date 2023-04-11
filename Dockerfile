FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
USER root
ENV HOME=/home/toolbox

RUN microdnf -y install yum && \
    yum -y -q install bash tar gzip unzip which shadow-utils findutils wget curl iputils bind-utils openssh openssh-clients sshpass \
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

RUN wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz && \
    sudo tar xzf openshift-client-linux.tar.gz -C /usr/local/sbin/ oc kubectl && \
    oc completion bash | sudo tee /etc/bash_completion.d/openshift > /dev/null

RUN cat /etc/passwd | \
    sed s#toolbox:x.*#toolbox:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
    > ${HOME}/passwd.template && \
    cat /etc/group | \
    sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
    > ${HOME}/group.template

ADD entrypoint.sh ${HOME}/
RUN chmod +x ${HOME}/*.sh

USER toolbox
ENTRYPOINT ["/home/toolbox/entrypoint.sh"]
WORKDIR /projects
CMD tail -f /dev/null
