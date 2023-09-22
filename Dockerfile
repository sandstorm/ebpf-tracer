FROM ubuntu:22.04

########################
# installing dev-tools #
########################

# for usage on OSX Docker hosts (does not hurt on other OS)
WORKDIR /
COPY --from=docker/for-desktop-kernel:5.15.49-release-0a38e305e2756e76c65c22c4be287df5591239a2 /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

# install various dev-tools
#      TODO also install https://github.com/dalance/procs ?
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2-utils \
    bash \
    bind9-utils \
    bird \
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


# install websocket debugging
#RUN curl -L -o websocat.deb https://github.com/vi/websocat/releases/download/v1.8.0/websocat_1.8.0_newer_amd64.deb && \
#    dpkg -i websocat.deb && \
#    rm websocat.deb

# install docker CLI
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
#    echo \
#      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#      jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#    apt update && \
#    apt-get install -y docker-ce-cli

#RUN  IG_VERSION=$(curl -s https://api.github.com/repos/inspektor-gadget/inspektor-gadget/releases/latest | jq -r .tag_name) \
#      IG_ARCH=amd64 \


# install traceloop
#COPY --from=kinvolk/traceloop:latest /bin/traceloop /bin/traceloop

# install bpftrace, also see https://github.com/iovisor/bpftrace/blob/master/INSTALL.md#building-bpftrace-1
RUN apt-get install -y libbpfcc-dev \
    bison \
    cmake \
    flex \
    g++ \
    git \
    libelf-dev \
    zlib1g-dev \
    libfl-dev \
    systemtap-sdt-dev \
    binutils-dev \
    libcereal-dev \
    llvm-dev \
    llvm-runtime \
    libclang-dev \
    clang \
    libpcap-dev \
    libgtest-dev \
    libgmock-dev \
    asciidoctor \
    libdw-dev \
    pahole
RUN git clone https://github.com/iovisor/bpftrace --recurse-submodules
RUN mkdir bpftrace/build; cd bpftrace/build; \
    ../build-libs.sh && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j8 && \
    make install

RUN apt install -y zip bison build-essential cmake flex git libedit-dev \
  libllvm14 llvm-14-dev libclang-14-dev python3 zlib1g-dev libelf-dev libfl-dev python3-setuptools \
  liblzma-dev libdebuginfod-dev arping netperf iperf

RUN git clone https://github.com/iovisor/bcc.git
RUN mkdir bcc/build; cd bcc/build && \
    cmake .. && \
    make && \
    make install
RUN cd bcc/build && \
    cmake -DPYTHON_CMD=python3 .. && \
    cd src/python/ && \
    make && \
    make install


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
    mkdir /bpf
    #ln -s /usr/bin/bpftrace /usr/local/bin/bpftrace

# add assets
ADD command.sh /command.sh
ADD prepare-bpf.sh /prepare-bpf.sh
ADD /bpf /bpf

RUN ln -s /usr/bin/python3  /usr/bin/python


# needed for tmux -CC attach
ENV LANG=UTF-8

# to avoid down-times due to "ops, wrong terminal"
# color the prompt according to $SHELL_ENV_DISPLAY variable
ADD bash.colorprompt.sh .
RUN cat bash.colorprompt.sh >> /root/.bashrc && \
    rm bash.colorprompt.sh
ENV SHELL_ENV_DISPLAY="production system"

WORKDIR /bpf
CMD ["/command.sh"]
