FROM hsci/twarc-docker

USER root

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd

USER 1000

ENV BUCKET tweets

VOLUME /s3cfg

CMD stdbuf -oL -eL /usr/local/bin/twarc --warnings --consumer_key $CONSUMER_KEY --consumer_secret $CONSUMER_SECRET --access_token $ACCESS_TOKEN --access_token_secret $ACCESS_TOKEN_SECRET --tweet_mode extended --log /dev/stderr $EXTRA_OPTS filter "$FILTER_EXPRESSION" | stdbuf -oL -eL split -d -a 9 -l $SPLIT --verbose --additional-suffix=.jsonl - /data/${DATA_FILE_PREFIX}_$(date +'%Y_%m_%d-%H_%M_%S'). | stdbuf -oL -eL sed -e "s/^creating file '//" -e "s/'$//" | stdbuf -oL -eL gawk -F. '{printf("%s.%09d.%s\n",$1,$2-1,$3)}' | xargs -n 1 -Ifn sh -c 'lrzip -D fn && s3cmd -c /s3cfg put fn.lrz s3://${BUCKET} && rm fn.lrz' 

