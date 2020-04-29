#!/bin/sh
OUTPUT_FILE=${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S')
echo Processing $@ into ${OUTPUT_FILE}
echo Processing $@ into ${OUTPUT_FILE} >> /data/merge.log
for file in "$@"
do
sort -o $file $file
done
SIZE=`python /merge.py $@ /data/tweetids.txt.gz /data/merge.log | lrz | s3cmd -c /credentials/s3cfg --progress put - s3://${FULL_BUCKET}/${OUTPUT_FILE}.jsonl.lrz | grep done | sed -e 's/^[^0-9]*//' -e 's/ of .*$//' | numfmt --to=iec && rm $@`
LINES=`tail -n 1 /data/merge.log | sed -e 's/^Wrote //' -e 's/ tweets.$//'`
echo "<li><a href=\"${OUTPUT_FILE}.jsonl.lrz\">${OUTPUT_FILE}.jsonl.lrz</a> (${LINES} tweets, ${SIZE})</li>" >> /data/index_full.html
s3cmd -c /credentials/s3cfg put /data/index_full.html s3://${FULL_BUCKET}/index.html
SIZE=`s3cmd -c /credentials/s3cfg --progress put /data/tweetids.txt.gz s3://${ID_BUCKET}/${OUTPUT_FILE}.txt.gz | grep done | sed -e 's/^[^0-9]*//' -e 's/ of .*$//' | numfmt --to=iec && rm /data/tweetids.txt.gz`
echo "<li><a href=\"${OUTPUT_FILE}.txt.gz\">${OUTPUT_FILE}.txt.gz</a> (${LINES} tweet ids, ${SIZE})</li>" >> /data/index_ids.html
s3cmd -c /credentials/s3cfg put /data/index_ids.html s3://${FULL_BUCKET}/index.html
