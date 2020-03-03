FROM python:3.7-alpine

RUN pip install twarc==1.7.5

ENV CONSUMER_KEY ""
ENV CONSUMER_SECRET ""
ENV ACCESS_TOKEN ""
ENV ACCESS_TOKEN_SECRET ""
ENV DATA_FILE_PREFIX tweets
ENV LOG_FILE twarc.log
ENV FILTER_EXPRESSION ""
ENV SPLIT 50000

VOLUME /data

WORKDIR /data

USER 1000

ENTRYPOINT /usr/local/bin/twarc --consumer_key $CONSUMER_KEY --consumer_secret $CONSUMER_SECRET --access_token $ACCESS_TOKEN --access_token_secret $ACCESS_TOKEN_SECRET --tweet_mode extended --log /data/$LOG_FILE filter "$FILTER_EXPRESSION" | gzip > /data/${DATA_FILE_PREFIX}_$(date +'%Y_%m_%d-%H_%M_%S').jsonl.gz
