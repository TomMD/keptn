#!/bin/bash

# For official releases we want to upload a helm-chart to google cloud
# This step involves downloading index.yaml and updating it
# as well as uploading the helm-chart with index.yaml

TARGET_DIRECTORY=${1:-"keptn-charts"}

# download index.yaml
gsutil cp gs://keptn-installer/index.yaml ${TARGET_DIRECTORY}${TARGET_DIRECTORY}/index.yaml

helm repo index ${TARGET_DIRECTORY} --url https://storage.googleapis.com/keptn-installer/ --merge ${TARGET_DIRECTORY}/index.yaml
if [ $? -ne 0 ]; then
  echo "Error generating index.yaml, exiting..."
  exit 1
fi

# upload to gcloud
gsutil cp ${TARGET_DIRECTORY}/index.yaml gs://keptn-installer/index.yaml
gsutil cp ${TARGET_DIRECTORY}/* gs://keptn-installer/
