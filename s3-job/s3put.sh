#!/bin/sh
OUTPUT_FILE=${DATA_FILE_PREFIX}_before_$(date +'%Y_%m_%d-%H_%M_%S')
echo Processing $@ into ${OUTPUT_FILE}
echo Processing $@ into ${OUTPUT_FILE} >> /data/merge.log
for file in "$@"
do
sort -o $file $file
done
SIZE=`python /merge.py $@ /data/${OUTPUT_FILE}_tweetids.txt.gz /data/merge.log | lrz | s3cmd -c /credentials/s3cfg --progress put - s3://${FULL_BUCKET}/${OUTPUT_FILE}.jsonl.lrz | grep done | sed -e 's/^[^0-9]*//' -e 's/ of .*$//' | numfmt --to=iec && rm $@`
LINES=`tail -n 1 /data/merge.log | sed -e 's/^Wrote //' -e 's/ tweets.$//'`
echo "<li><a href=\"${OUTPUT_FILE}.jsonl.lrz\">${OUTPUT_FILE}.jsonl.lrz</a> (${LINES} tweets, ${SIZE})</li>" >> /data/index_full.html
s3cmd -c /credentials/s3cfg put /data/index_full.html s3://${FULL_BUCKET}/index.html
s3cmd -c /credentials/s3cfg put /data/merge.log s3://${FULL_BUCKET}/merge.log
SIZE=`du -sh /data/${OUTPUT_FILE}_tweetids.txt.gz | cut -f 1`
s3cmd -c /credentials/s3cfg put /data/${OUTPUT_FILE}_tweetids.txt.gz s3://${ID_BUCKET}/${OUTPUT_FILE}_tweetids.txt.gz && rm /data/${OUTPUT_FILE}_tweetids.txt.gz
echo "<li><a href=\"${OUTPUT_FILE}_tweetids.txt.gz\">${OUTPUT_FILE}_tweetids.txt.gz</a> (${LINES} tweet ids, ${SIZE})</li>" >> /data/index_ids.html
s3cmd -c /credentials/s3cfg put /data/index_ids.html s3://${ID_BUCKET}/index.html
s3cmd -c /credentials/s3cfg put /data/merge.log s3://${ID_BUCKET}/merge.log
