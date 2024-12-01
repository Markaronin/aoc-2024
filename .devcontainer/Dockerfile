FROM ubuntu:22.04

RUN <<EOF
    apt-get update
    apt-get -y install git curl sudo xz-utils
EOF

ARG REMOTE_USER
ARG REMOTE_UID
ARG REMOTE_GID
RUN <<EOF
    useradd ${REMOTE_USER} --create-home
EOF

ENV HOME /home/${REMOTE_USER}

USER ${REMOTE_USER}

RUN <<EOF
    mkdir $HOME/.zig
    curl https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz | tar --extract --xz --file - --directory $HOME/.zig --strip-components 1
    curl https://builds.zigtools.org/zls-linux-x86_64-0.13.0.tar.xz | tar --extract --xz --file - --directory $HOME/.zig
EOF
ENV PATH $HOME/.zig:$PATH
