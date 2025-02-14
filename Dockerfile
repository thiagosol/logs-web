FROM node:14

WORKDIR /app

RUN npm install -g log.io --unsafe-perm=true --allow-root
RUN node -v && npm -v && npm list -g --depth=0
RUN which log.io-server && which log.io-harvester

RUN mkdir -p /var/log/logs-web && chmod -R 777 /var/log/logs-web

ARG LOG_USER
ARG LOG_PASS

RUN echo "$LOG_USER:$(echo -n $LOG_PASS | md5sum | awk '{print $1}')" > /root/.log.io-users
RUN chmod 600 /root/.log.io-users

RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 28778 28777

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
