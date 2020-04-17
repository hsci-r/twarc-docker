FROM hsci/twarc-docker:base

ENV BUCKET tweets

COPY s3put.sh /s3put.sh

CMD find /data/ -name '*.jsonl' -exec sh /s3put.sh {} \+
