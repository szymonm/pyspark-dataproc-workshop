#!/bin/bash

while read p; do
    echo $p
    filename=`basename $p`
    gsutil cp $p gs://$BUCKET_NAME/so-posts/$filename &
    sleep 1
done < dataset.txt

