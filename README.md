# large scale data management

Page rank in Pig and Pyspark, based on https://github.com/momo54/large_scale_data_management
Modified for running on Google Cloud Dataproc.

## data

Data is publicly available on cloud, we only reference it for usage(see pig and pyspark codes). But it's available at: http://downloads.dbpedia.org/3.5.1/en/page_links_en.nt.bz2 (keep it compressed).

To create a bucket to store code and output:

```
gcloud storage buckets create gs://BUCKET_NAME --project=PROJECT_ID  --location=europe-west1 --uniform-bucket-level-access
```

## Pig

### Cluster creation

- To create the cluster with a certain NUM_WORKERS:

```
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers NUM_WORKERS --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project PROJECT_ID
```

- To create the cluster with a single node:

```
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --single-node --image-version 2.0-debian10 --project PROJECT_ID
```

### Copying pig code from local

```
gsutil cp dataproc.py gs://BUCKET_NAME/
```

### Clearing output directory

```
gsutil rm -rf gs://BUCKET_NAME/out
```

### Running

Once code is uploaded to bucket and dataproc.py code is updated run :

```
gcloud dataproc jobs submit pig --region europe-west1 --cluster cluster-a35a --project PROJECT_ID -f gs://BUCKET_NAME/dataproc.py
```

### Deleting the cluster

Do not forget to stop your cluster at when job is finished.

```
gcloud dataproc clusters delete cluster-a35a --region europe-west1
```

# Pyspark
