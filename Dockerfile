FROM mephux/log.io

ARG LOG_USER
ARG LOG_PASS

RUN echo "$LOG_USER:$(echo -n $LOG_PASS | md5sum | awk '{print $1}')" > /root/.log.io-users
RUN chmod 600 /root/.log.io-users

RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir -p /var/log/supervisor

EXPOSE 28778 28777

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
