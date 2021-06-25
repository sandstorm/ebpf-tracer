FROM docker/for-desktop-kernel:desktop-3.3.1 AS ksrc

FROM nicolaka/netshoot:latest


WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

 # https://github.com/dalance/procs
RUN apk add bpftrace bpftrace-tools bcc bcc-tools \
    procs
RUN apk add docker-cli

WORKDIR /root
ADD motd /root/motd
ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]