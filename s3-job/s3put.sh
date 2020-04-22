#!/bin/sh
echo Processing $@
for file in "$@"
do
sort -o $file $file
done
python /merge.py $@ /data/tweetids.txt.gz /data/merge.log | lrz | s3cmd -c /credentials/s3cfg put - s3://${FULL_BUCKET}/${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S').jsonl.lrz && rm $@ && s3cmd -c /credentials/s3cfg put /data/tweetids.txt.gz s3://${ID_BUCKET}/${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S').txt.gz && rm /data/tweetids.txt.gz

