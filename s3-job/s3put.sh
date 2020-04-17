#!/bin/sh
echo Processing $@
sort -u $@ | lrz | s3cmd -c /s3cfg put - s3://${BUCKET}/${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S').jsonl.lrz && rm $@

