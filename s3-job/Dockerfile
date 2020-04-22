FROM hsci/twarc-docker:base

ENV ID_BUCKET tweetids
ENV FULL_BUCKET tweets

COPY s3put.sh /s3put.sh

COPY merge.py /merge.py

CMD find /data/ -name '*.jsonl' -exec sh /s3put.sh {} \+
