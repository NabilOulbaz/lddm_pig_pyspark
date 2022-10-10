# large scale data management

Page rank in Pig and Pyspark, based on https://github.com/momo54/large_scale_data_management
Modified for running on Google Cloud Dataproc.

## data

Data is publicly available on cloud, we only reference it for usage(see pig and pyspark codes). But it's available at: http://downloads.dbpedia.org/3.5.1/en/page_links_en.nt.bz2 (keep it compressed).

To create a bucket to store code and output:

```
gcloud storage buckets create gs://BUCKET_NAME --project=PROJECT_ID  --location=europe-west1 --uniform-bucket-level-access
```

## Cluster creation

- To create the cluster with a certain NUM_WORKERS:

```
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers NUM_WORKERS --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project PROJECT_ID
```

- To create the cluster with a single node:

```
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --single-node --image-version 2.0-debian10 --project PROJECT_ID
```

## Pig

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

## Pyspark

### Copying pig code from local

```
gsutil cp pagerank-notype.py gs://BUCKET_NAME/
```

### Clearing output directory

```
gsutil rm -rf gs://BUCKET_NAME/out
```

### Running

Once code is uploaded to bucket run :

```
gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a gs://BUCKET_NAME/pagerank-notype.py  -- gs://public_lddm_data/page_links_en.nt.bz2 3
```

### Deleting the cluster

Do not forget to stop your cluster at when job is finished.

```
gcloud dataproc clusters delete cluster-a35a --region europe-west1
```

## Performance comparison

We ran the pagerank script in both **Pig** and **Pyspark** in different size clusters:

- 1 node : Master node only
- 3 nodes : 1 Master node and 2 Worker nodes
- 5 nodes : 1 Master node and 4 Worker nodes

The table below is a collection of the different durations for each test:

|           |        Pig | Pyspark |
| :-------: | ---------: | ------: |
| 0 Workers | 1h 35m 14s |         |
| 2 Workers |     50m 6s | 44m 10s |
| 4 Workers |    36m 27s | 25m 59s |
| 5 Workers |    33m 16s | 34m 00s |
