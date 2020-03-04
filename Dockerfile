FROM python:3.7-alpine

RUN apk add --no-cache tini coreutils lrzip gawk
# RUN apk add --no-cache dumb-init coreutils

RUN pip install twarc==1.7.5

ENV CONSUMER_KEY ""
ENV CONSUMER_SECRET ""
ENV ACCESS_TOKEN ""
ENV ACCESS_TOKEN_SECRET ""
ENV DATA_FILE_PREFIX tweets
ENV FILTER_EXPRESSION ""
ENV SPLIT 50000

VOLUME /data

WORKDIR /data

USER 1000

ENTRYPOINT ["/sbin/tini", "-g", "--"]
# ENTRYPOINT ["/usr/bin/dumb-init", "--rewrite", "15:2", "--"]

CMD /usr/local/bin/twarc --warnings --consumer_key $CONSUMER_KEY --consumer_secret $CONSUMER_SECRET --access_token $ACCESS_TOKEN --access_token_secret $ACCESS_TOKEN_SECRET --tweet_mode extended --log /dev/stderr filter "$FILTER_EXPRESSION" | stdbuf -oL -eL split -d -a 9 -l $SPLIT --verbose --additional-suffix=.jsonl - /data/${DATA_FILE_PREFIX}_$(date +'%Y_%m_%d-%H_%M_%S'). | stdbuf -oL -eL sed -e "s/^creating file '//" -e "s/'$//" | stdbuf -oL -eL gawk -F. '{printf("%s.%09d.%s\n",$1,$2-1,$3)}' | xargs -n 1 lrzip -D
