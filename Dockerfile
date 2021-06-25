FROM ubuntu:focal

########################
# installing dev-tools #
########################

# for usage on OSX Docker hosts (does not hurt on other OS)
WORKDIR /
COPY --from=docker/for-desktop-kernel:desktop-3.3.1 /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

# install various dev-tools
#      TODO also install https://github.com/dalance/procs ?
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2-utils \
    bash \
    bind9-utils \
    bird \
    bpfcc-tools \
    bridge-utils \
    conntrack \
    ctop \
    curl \
    dhcping \
    dnsutils \
    ethtool \
    file \
    fping \
    gnupg \
    httpie \
    iftop \
    iperf \
    iproute2 \
    ipset \
    iptables \
    iptraf-ng \
    iputils-arping iputils-clockdiff iputils-ping iputils-tracepath \
    ipvsadm \
    jq \
    less \
    mtr \
    screen \
    snmp \
    netcat-openbsd \
    netgen \
    nftables \
    ngrep \
    nmap \
    openssl \
    python2 \
    scapy \
    socat \
    strace \
    tcpdump \
    tcptraceroute \
    termshark \
    tmux \
    tshark \
    util-linux \
    vim

# install calico
RUN cd /usr/local/bin \
    && curl -o calicoctl -O -L "https://github.com/projectcalico/calicoctl/releases/download/v3.19.1/calicoctl" \
    && chmod +x calicoctl

# install websocket debugging
RUN curl -L -o websocat.deb https://github.com/vi/websocat/releases/download/v1.8.0/websocat_1.8.0_newer_amd64.deb && \
    dpkg -i websocat.deb && \
    rm websocat.deb

# install docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      focal stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    apt-get install -y docker-ce-cli

# install traceloop
COPY --from=kinvolk/traceloop:latest /bin/traceloop /bin/traceloop

# install bpftrace, also see https://github.com/iovisor/bpftrace/blob/master/INSTALL.md#copying-bpftrace-binary-from-docker
COPY --from=quay.io/iovisor/bpftrace:master-vanilla_llvm_clang_glibc2.27 /usr/bin/bpftrace /usr/bin/bpftrace
COPY --from=quay.io/iovisor/bpftrace:master-vanilla_llvm_clang_glibc2.27 /usr/local/bin/* /usr/local/bin/

############################
# setting up the container #
############################

WORKDIR /root

# bash welcoming message
ADD motd /etc/motd
RUN echo 'cat /etc/motd' >> /etc/profile && echo 'cat /etc/motd' >> /etc/bash.bashrc

# BPF dependencies
RUN touch /usr/src/.notmounted && \
    mkdir /lib/modules && \
    touch /lib/modules/.notmounted && \
    mkdir /bpf && \
    ln -s /usr/bin/bpftrace /usr/local/bin/bpftrace

# add assets
ADD entrypoint.sh /entrypoint.sh
ADD prepare-bpf.sh /prepare-bpf.sh
ADD /bpf /bpf

# needed for tmux -CC attach
ENV LANG=UTF-8

CMD ["/entrypoint.sh"]
