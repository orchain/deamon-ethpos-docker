FROM block.com/beaconbase
ARG DATA_DIR
ARG HOST_IP
ARG PEER_IP_LIST
ARG FEE_RECIPIENT
ENV APP_ENV=local
ENV DATA_DIR=${DATA_DIR}
ENV HOST_IP=${HOST_IP}
ENV PEER_IP_LIST=${PEER_IP_LIST}
ENV FEE_RECIPIENT=${FEE_RECIPIENT}
ENV CGO_CFLAGS="-O -D__BLST_PORTABLE__"


RUN mkdir ${DATA_DIR} /data-ephemeral \
  && chown -R ${SYMBOL}:${SYMBOL} ${DATA_DIR} /data-ephemeral 

# copy static node info
COPY consensus-docker/resources/supervisord.conf /etc/supervisord.conf
COPY consensus-docker/resources/chown.supervisor.conf.j2 /etc/supervisor/conf.d/chown.supervisor.conf.j2
COPY consensus-docker/resources/daemon.supervisor.conf.j2 /etc/supervisor/conf.d/daemon.supervisor.conf.j2
COPY consensus-docker/resources/start_beacon.sh /usr/local/bin/start_beacon.sh
COPY consensus-docker/resources/start_validator.sh /usr/local/bin/start_validator.sh

RUN dos2unix /usr/local/bin/start_beacon.sh
RUN dos2unix /usr/local/bin/start_validator.sh
# transform jinja template to configuration file
RUN j2 /etc/supervisor/conf.d/daemon.supervisor.conf.j2 > /etc/supervisor/conf.d/${SYMBOL}.supervisor.conf
RUN j2 /etc/supervisor/conf.d/chown.supervisor.conf.j2 > /etc/supervisor/conf.d/chown.supervisor.conf
RUN chmod +x /usr/local/bin/start_beacon.sh
RUN chmod +x /usr/local/bin/start_validator.sh
RUN rm -f /etc/supervisor/conf.d/*.j2 /*.j2

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
