FROM python:alpine3.14

WORKDIR /app

ARG VERSION
ARG SYMBOL
ARG SOURCE_CODE
ARG DATA_DIR
ARG CLI_COMMAND

ENV APP_ENV=local
ENV VERSION=${VERSION}
ENV SYMBOL=${SYMBOL}
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
    
ENV DATA_DIR=${DATA_DIR}

RUN addgroup -g 1000 -S "${SYMBOL}" \
    && adduser "${SYMBOL}" -D -G "${SYMBOL}" -u 1000 -s /bin/sh

RUN apk add --update gcc libc-dev linux-headers git 

COPY staking-cli-docker/resources/config_deposit.yml /

#instal staking cli
RUN git clone --branch ${VERSION} ${SOURCE_CODE} \
    && cd staking-deposit-cli \
    && pip3 install pyyaml \
    && pip3 install -r requirements.txt \
    && python3 setup.py install 

RUN mkdir -p "/home/${SYMBOL}" \
  && chown -R "${SYMBOL}:${SYMBOL}" "/home/${SYMBOL}" \
  && mkdir ${DATA_DIR}  \
  && chown -R ${SYMBOL}:${SYMBOL} ${DATA_DIR}

WORKDIR staking-deposit-cli

ENTRYPOINT [ "python3", "staking_deposit/deposit.py" ]

CMD [ $CLI_COMMAND ]

