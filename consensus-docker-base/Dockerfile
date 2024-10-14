FROM golang:1.20
ARG VERSION
ARG SYMBOL
ARG SOURCE_CODE
ARG CONFIG_BASE_DIR

ENV APP_ENV=local
ENV VERSION=${VERSION}
ENV SYMBOL=${SYMBOL}
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
ENV CONFIG_BASE_DIR=${CONFIG_BASE_DIR}
ENV CGO_CFLAGS="-O -D__BLST_PORTABLE__"
# 修改时区
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    procps \
    python3 \
    python3-distutils \
    unzip \
    git \
    make \
    cmake \
    gcc \
    xz-utils \
    lbzip2 \
    tar \
    gzip \
    net-tools \
    supervisor \
    j2cli \
    iputils-ping \
    telnet \
    python3-pip \
    dos2unix \
    jq \
    netcat-traditional \
  && export DEBIAN_FRONTEND=noninteractive \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -Urs /usr/sbin/nologin "${SYMBOL}"

#instal consensus client
RUN git clone --branch ${VERSION} ${SOURCE_CODE} \
    && cd prysm \
    && go build -o=../beacon-chain ./cmd/beacon-chain \
    && go build -o=../validator ./cmd/validator \
    && go build -o=../prysmctl ./cmd/prysmctl \
    && mv /go/beacon-chain /usr/local/bin/ \
    && mv /go/prysmctl /usr/local/bin/ \
    && mv /go/validator /usr/local/bin/


COPY consensus-docker-base/resources/config.yml /config.yml
COPY consensus-docker-base/resources/genesis.json /genesis.json
COPY consensus-docker-base/resources/beacon_init.sh /usr/local/bin/
COPY consensus-docker-base/resources/validator_init.sh /usr/local/bin/
COPY consensus-docker-base/resources/account_password /account_password
COPY consensus-docker-base/resources/wallet_password /wallet_password

RUN dos2unix /usr/local/bin/beacon_init.sh
RUN dos2unix /usr/local/bin/validator_init.sh

RUN mkdir -p "/home/${SYMBOL}" \
  && chown -R "${SYMBOL}:${SYMBOL}" "/home/${SYMBOL}" \
  && mkdir ${CONFIG_BASE_DIR} \
  && chown -R ${SYMBOL}:${SYMBOL} ${CONFIG_BASE_DIR} \
  && chmod 750 /usr/local/bin/beacon_init.sh /usr/local/bin/validator_init.sh

ENTRYPOINT [ "/bin/bash","-c"]

CMD [ $CLI_COMMAND ]
