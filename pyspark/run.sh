#!/bin/bash

## En local ->
## pig -x local -

## en dataproc...

## copy data
gsutil cp small_page_links.nt gs://nabils_bucket/

## copy pig code
gsutil cp pagerank-notype.py gs://nabils_bucket/

## Clean out directory
gsutil rm -rf gs://nabils_bucket/out


## create the cluster
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project lddm-364917


## run
## (suppose that out directory is empty !!)
gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a gs://nabils_bucket/pagerank-notype.py  -- gs://public_lddm_data/page_links_en.nt.bz2 3

## access results
gsutil cat gs://nabils_bucket/out/pagerank_data_3/part-r-00000

## delete cluster...
gcloud dataproc clusters delete cluster-a35a --region europe-west1

