# pyspark-dataproc-workshop

## Setup

You can use how-to from [dataproc documentation](https://cloud.google.com/dataproc/docs/guides/setup-project).

### Gcloud account

Hope you have it by now. If not, you need to go to [google cloud main page](https://cloud.google.com/) and click *Try it for free* button (top right).

You will need to provide data of your credit card :/. Sorry, Google apparently can't do anything about that.

Make sure to enable dataproc API (here)[https://console.cloud.google.com/flows/enableapi?apiid=dataproc].

Remember your `project-id`. You gonna need it later.

### Gcloud SDK

Install `gcloud` tool for your system from [here](https://cloud.google.com/sdk/downloads).

`gcloud` is a tool to manage your cloud account from terminal.

**Make sure you can create default bucket:**

Basic setup:
```
export PROJECT_NAME =<<YOUR PROJECT NAME>>
export BUCKET_NAME=<<YOUR BUCKET NAME>> # my-weird-bucket-name123
export CLUSTER_NAME=cluster-1
```

Make sure you use the proper account:
```
gcloud account login
```

Set defaults (don't ask):
```
gcloud config set project $PROJECT_NAME
gcloud config set compute/zone europe-west1-c
```

Create a bucket (we will need it for our cluster):
```
gsutil mb gs://$BUCKET_NAME
```

### Running cluster

Make sure you have environment variables set from the previous step.

```
gcloud dataproc clusters create $CLUSTER_NAME \
--project $PROJECT_NAME \
--bucket $BUCKET_NAME \
--initialization-action-timeout 1200 \
--initialization-actions gs://pyspark-workshop/init.sh \
--master-machine-type n1-standard-1 \
--master-boot-disk-size 50 \
--num-workers 3 \
--worker-machine-type n1-standard-2 \
--num-worker-local-ssds 1 \
--worker-boot-disk-size 200 \
--image-version 1.0 \
--num-preemptible-workers 0
```

You can also use (graphical UI)[https://console.cloud.google.com/dataproc/clusters].

### Port forwarding

We will need some port exposed from our machine:

You can use socks proxy (if you use chrome and like this concept):
```
gcloud compute ssh \
  --ssh-flag="-D" --ssh-flag="10000" --ssh-flag="-N" "$CLUSTER_NAME-m"
```

And open your browser using:
```
<browser executable path> \
    "http://$CLUSTER_NAME-m:8123" \
    --proxy-server="socks5://localhost:10000" \
    --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost" \
    --user-data-dir=/tmp/
```
where browser executable path is:
1. `/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome` for MacOS.
2. `google-chrome` for Linux.
3. `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe` for Win.


---
You can also use port forwarding (if you feel more familiar with it):
```
gcloud compute ssh $CLUSTER_NAME-m -- -vvv \
        -L 8123:localhost:8123 \
        -L 8080:localhost:8080 \
        -L 8088:localhost:8088
```
---

### Verification

Check you can access jupiter notebook on port `8123` and Yarn UI on port `8088`.
