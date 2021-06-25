FROM docker/for-desktop-kernel:desktop-3.3.1 AS ksrc




FROM ubuntu:focal

# this is for !!MAC OS!!
WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

 # https://github.com/dalance/procs
 RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2-utils \
    bash \
    bind9-utils \
    bird \
    bridge-utils \
    conntrack \
    ctop \
    curl \
    dhcping \
    ethtool \
    file \
    fping \
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
    mtr \
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
    tshark \
    util-linux \
    vim

# calico
RUN cd /usr/local/bin \
    && curl -o calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.19.1/calicoctl" \
    && chmod +x calicoctl

# websocket debugging
RUN curl -L -o websocat.deb https://github.com/vi/websocat/releases/download/v1.8.0/websocat_1.8.0_newer_amd64.deb && dpkg -i websocat.deb && rm websocat.deb

# docker CLI
RUN apt-get install -y gnupg && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    focal stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli

COPY --from=kinvolk/traceloop:latest /bin/traceloop /bin/traceloop

# BPF CC (BCC)
RUN apt-get install -y bpfcc-tools

# bpftrace https://github.com/iovisor/bpftrace/blob/master/INSTALL.md#copying-bpftrace-binary-from-docker
COPY --from=quay.io/iovisor/bpftrace:master-vanilla_llvm_clang_glibc2.27 /usr/bin/bpftrace /usr/bin/bpftrace
COPY --from=quay.io/iovisor/bpftrace:master-vanilla_llvm_clang_glibc2.27 /usr/local/bin/* /usr/local/bin/

# setting up the container
WORKDIR /root
ADD motd /etc/motd
RUN echo 'cat /etc/motd' >> /etc/profile &&  echo 'cat /etc/motd' >> /etc/bash.bashrc \
    && touch /usr/src/.notmounted && mkdir /lib/modules && touch /lib/modules/.notmounted \
    && mkdir /bpf
ADD entrypoint.sh /entrypoint.sh
ADD prepare-bpf.sh /prepare-bpf.sh
ADD /bpf /bpf


CMD ["/entrypoint.sh"]
