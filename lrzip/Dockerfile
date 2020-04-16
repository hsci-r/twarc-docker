FROM hsci/twarc-docker

CMD stdbuf -oL -eL /usr/local/bin/twarc --warnings --consumer_key $CONSUMER_KEY --consumer_secret $CONSUMER_SECRET --access_token $ACCESS_TOKEN --access_token_secret $ACCESS_TOKEN_SECRET --tweet_mode extended --log /dev/stderr $EXTRA_OPTS filter "$FILTER_EXPRESSION" | stdbuf -oL -eL split -d -a 9 -l $SPLIT --verbose --additional-suffix=.jsonl - /data/${DATA_FILE_PREFIX}_$(date +'%Y_%m_%d-%H_%M_%S'). | stdbuf -oL -eL gawk -F"[. ']" '{printf("%s.%09d.%s\n",$4,$5-1,$6)}' | xargs -n 1 lrzip -D
