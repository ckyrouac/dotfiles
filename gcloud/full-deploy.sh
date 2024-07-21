#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This will completely "refresh" the image on google cloud
# and create a new VM using the refreshed image.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set -e

EMAIL=$1
PROJECT=$2
BIB_CONFIG=$3
BUTANE=$4

IMAGE_NAME='fedora-dev-bootc'
ZONE='us-east4-a'
MACHINE_TYPE='c2-standard-8'

function build_container_image () {
    info_msg "building container image"
    podman build \
        --build-arg "gituser=ckyrouac" \
        --build-arg "gitemail=$EMAIL" \
        --build-arg "user=chris" \
        -t "ghcr.io/ckyrouac/$IMAGE_NAME" .
    podman push "ghcr.io/ckyrouac/$IMAGE_NAME"
}

function build_disk_image () {
    info_msg "building vmdk disk image via bib"
    rm -rf output
    mkdir -p output

    podman run \
        --rm \
        -it \
        --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v "$(pwd)/output:/output" \
        -v "$BIB_CONFIG:/config.toml:ro" \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --rootfs xfs \
        --type vmdk \
        --local \
        "ghcr.io/ckyrouac/$IMAGE_NAME"
}

function cleanup_gcloud () {
    info_msg "cleaning up existing gcloud resources"
    set +e
    gcloud alpha migration vms image-imports delete "$IMAGE_NAME"
    gcloud storage rm gs://ckyrouac-logs/disk.vmdk
    gcloud compute images delete "$IMAGE_NAME"
    gcloud compute instances delete "$IMAGE_NAME"
    set -e
}

function upload_disk_image () {
    info_msg "uploading vmdk disk image"
    gcloud storage cp ./output/vmdk/disk.vmdk gs://ckyrouac-logs
}

function migrate_disk_image () {
    info_msg "migrating vmdk to gcloud image"
    gcloud alpha migration vms image-imports create \
        "$IMAGE_NAME" \
        --source-file=gs://ckyrouac-logs/disk.vmdk \
        --target-project="projects/${PROJECT}/locations/global/targetProjects/${PROJECT}" \
        --skip-os-adaptation
}

function create_vm () {
    info_msg "creating new vm"

    rm -f fedora-dev.ign

    butane --pretty --strict "$BUTANE" > fedora-dev.ign

    CONFIG='fedora-dev.ign'
    gcloud compute instances create              \
        --image-project "development-429901"    \
        --image "${IMAGE_NAME}" \
        --metadata-from-file "user-data=${CONFIG}" \
        --zone "${ZONE}" "${IMAGE_NAME}" \
        --machine-type "$MACHINE_TYPE"
}

function info_msg () {
  echo -en "\n$1\n"
}

build_container_image
build_disk_image
cleanup_gcloud
upload_disk_image
migrate_disk_image
create_vm
