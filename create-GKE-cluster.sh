#!/usr/bin/env bash

source .env

echo "01 ---- set env variables ----"

echo "gcp-project-id=${PROJECT_ID}"
echo "region=${REGION}"

gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${ZONE}
gcloud config set compute/region ${REGION}


echo "02 ---- create GKE cluster ----"

gcloud beta container clusters create "core-cluster" \
            --project ${PROJECT_ID} \
            --region ${REGION} \
            --machine-type ${MACHINE_TYPE} \
            --metadata disable-legacy-endpoints=true \
            --num-nodes ${NUM_NODES} \
            --no-enable-basic-auth \
            --enable-stackdriver-kubernetes \
            --enable-ip-alias \
            --no-enable-master-authorized-networks \
            --addons HorizontalPodAutoscaling,HttpLoadBalancing \
            --enable-autoupgrade \
            --enable-autorepair \
            --tags "core"

echo "03 ---- configure kubectl command ----"

gcloud container clusters get-credentials ${CLUSTER_NAME} \
            --region=${REGION}

kubectl cluster-info

#gcloud container clusters resize --region europe-west4 core-cluster --num-nodes=0
