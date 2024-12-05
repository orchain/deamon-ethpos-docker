FROM golang:1.20

ARG VERSION
ARG SYMBOL
ARG SOURCE_CODE
ARG CONFIG_BASE_DIR
ARG DATA_DIR

ENV APP_ENV=local
ENV PYTHON_PIP_VERSION 21.1.3
ENV VERSION=${VERSION}
ENV SYMBOL=${SYMBOL}
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
ENV CONFIG_BASE_DIR=${CONFIG_BASE_DIR}
ENV DATA_DIR=${DATA_DIR}

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
    dos2unix \
    jq \
    netcat-traditional \
  && export DEBIAN_FRONTEND=noninteractive \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -Urs /usr/sbin/nologin "${SYMBOL}"

# 修改时区
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

#instal geth env
RUN git clone --branch ${VERSION} ${SOURCE_CODE} \
    && cd go-ethereum \
    && make all \
    && mv /go/go-ethereum/build/bin/* /usr/local/bin/

COPY execution-docker-base/resources/eth_init.sh /usr/local/bin/

RUN mkdir -p "/home/${SYMBOL}" \
  && chown -R "${SYMBOL}:${SYMBOL}" "/home/${SYMBOL}" \
  && mkdir  ${CONFIG_BASE_DIR} ${DATA_DIR}\
  && chown -R ${SYMBOL}:${SYMBOL} ${CONFIG_BASE_DIR} ${DATA_DIR} \
  && chmod 750 /usr/local/bin/eth_init.sh \
  && dos2unix /usr/local/bin/eth_init.sh

RUN echo 'Asia/Shanghai' > /etc/timezone

# ENTRYPOINT [ "/bin/bash","-c"]

CMD [ $CLI_COMMAND ]
