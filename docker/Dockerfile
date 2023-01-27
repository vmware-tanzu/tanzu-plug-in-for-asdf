FROM ubuntu:22.04

RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apt update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt install -y software-properties-common \
    && add-apt-repository -y "ppa:fish-shell/nightly-master" \
    && apt install -y --no-install-recommends \
        ca-certificates libarchive-tools curl unzip git fish vim  \
    \
    && apt autoremove -y \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && rm -rf /tmp/* \
    && apt-get clean

RUN useradd -ms /bin/bash tester
USER tester
WORKDIR /home/tester
RUN mkdir -p /home/tester/.local && mkdir -p /home/tester/.local/bin
RUN echo "export PATH=$PATH:$HOME/.local/bin; source $HOME/.bashrc" > $HOME/.bash_profile