FROM alpine:3.6
MAINTAINER cperezcerrato@gmail.com

RUN apk update \
  && apk add autossh \
  && rm -rf var/cache/apk

RUN adduser -S -D -h /home/autossh autossh \
  && mkdir /home/autossh/.ssh
COPY start.sh /home/autossh/
RUN  chown -R autossh: /home/autossh

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod 755 /usr/local/bin/dumb-init

USER autossh
WORKDIR /home/autossh

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["./start.sh"]
