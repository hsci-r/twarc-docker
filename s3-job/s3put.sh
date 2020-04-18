#!/bin/sh
echo Processing $@
for file in "$@"
do
sort -o $file $file
done
python /merge.py $@ | lrz | s3cmd -c /credentials/s3cfg put - s3://${BUCKET}/${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S').jsonl.lrz && rm $@

