FROM alpine:latest

RUN cp /etc/apk/repositories /etc/apk/repositories.orig \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache \
        curl owncloud-client

ADD startup.sh /startup.sh

CMD [ "/startup.sh" ]
