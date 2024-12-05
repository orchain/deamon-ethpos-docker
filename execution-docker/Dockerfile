FROM block.com/gethbase

ARG PORT_RPC
ARG EXTIP
ARG PEER_IP_LIST
ENV APP_ENV local
ENV SYMBOL=${SYMBOL}
ENV PORT_RPC=${PORT_RPC}
ENV EXTIP=${EXTIP}
ENV PEER_IP_LIST=${PEER_IP_LIST}
RUN mkdir /data-ephemeral \
  && chown -R ${SYMBOL}:${SYMBOL} /data-ephemeral 

# copy static node info
COPY execution-docker/resources/supervisord.conf /etc/supervisord.conf
COPY execution-docker/resources/chown.supervisor.conf.j2 /etc/supervisor/conf.d/chown.supervisor.conf.j2
COPY execution-docker/resources/daemon.supervisor.conf.j2 /etc/supervisor/conf.d/daemon.supervisor.conf.j2
COPY execution-docker/resources/start_eth.sh /usr/local/bin/start_eth.sh
COPY execution-docker/resources/config.tmp /etc/config.tmp
COPY execution-docker/resources/jwtsecret /etc/jwtsecret

# transform jinja template to configuration file
RUN j2 /etc/supervisor/conf.d/daemon.supervisor.conf.j2 > /etc/supervisor/conf.d/${SYMBOL}.supervisor.conf \
  && j2 /etc/supervisor/conf.d/chown.supervisor.conf.j2 > /etc/supervisor/conf.d/chown.supervisor.conf \
  && chmod +x /usr/local/bin/start_eth.sh \
  && rm -f /etc/supervisor/conf.d/*.j2 /*.j2 \
  && dos2unix /usr/local/bin/start_eth.sh


RUN echo 'Asia/Shanghai' > /etc/timezone

EXPOSE ${PORT_RPC:-8545}
EXPOSE 8551
EXPOSE 30303

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
