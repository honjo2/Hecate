FROM ubuntu:18.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV SHELL /bin/bash

# set the locale
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        software-properties-common \
        libcurl4-openssl-dev \
        apt-transport-https \
        postgresql-contrib \
        build-essential \
        libiberty-dev \
        binutils-dev \
        pkg-config \
        zlib1g-dev \
        postgresql \
        libssl-dev \
        libelf-dev \
        libdw-dev \
        locales \
        postgis \
        openssl \
        cmake \
        curl \
        wget \
        git \
        gcc \
        git \
    && locale-gen en_US.UTF-8 \
    && bash -c "echo \"America/New_York\" > /etc/timezone"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl 'https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.gz' | tar -xzv \
    && cp ./node-v10.15.3-linux-x64/bin/node /usr/bin/ \
    && ./node-v10.15.3-linux-x64/bin/npm install -g npm \
    && npm install -g yarn


RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.40.0

RUN echo "local all all trust " > /etc/postgresql/10/main/pg_hba.conf \
    && echo "host all all 127.0.0.1/32 trust" >> /etc/postgresql/10/main/pg_hba.conf \
    && echo "host all all ::1/128 trust" >> /etc/postgresql/10/main/pg_hba.conf

WORKDIR /usr/local/src/hecate
ADD . /usr/local/src/hecate

CMD ./test.sh
