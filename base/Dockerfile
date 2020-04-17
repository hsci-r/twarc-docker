FROM python:3.7-alpine

RUN apk add --no-cache tini coreutils lrzip gawk jq rsync && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd && pip install twarc==1.7.5

ENV CONSUMER_KEY ""
ENV CONSUMER_SECRET ""
ENV ACCESS_TOKEN ""
ENV ACCESS_TOKEN_SECRET ""
ENV DATA_FILE_PREFIX tweets
ENV FILTER_EXPRESSION ""
ENV EXTRA_OPTS ""
ENV SPLIT 50000

VOLUME /data
VOLUME /credentials

WORKDIR /data

USER 1000

ENTRYPOINT ["/sbin/tini", "-g", "--"]

