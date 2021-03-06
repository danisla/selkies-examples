## GZDoom Demo

## Description

This example shows how to stream an instance of [GZDoom](https://zdoom.org/) using the GKE WebRTC VDI stack.

## Dependencies

- App Launcher: [v1.0.0+](https://github.com/GoogleCloudPlatform/solutions-k8s-stateful-workload-operator/tree/v1.0.0)
- WebRTC Streaming Stack: [v1.4.0+](https://github.com/GoogleCloudPlatform/solutions-webrtc-gpu-streaming/tree/v1.4.0)

## Features

- GZDoom in a container.
- Uses App Streaming base image.

## Installed Software

- GZDoom
- Freedoom
- Brutal Doom

## Tutorials

This tutorial will walk you through the following:

- Verifying cluster pre-requisites.
- Building the image and deploying the manifests with Cloud Build.

## Setup

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```bash
export PROJECT_ID=YOUR_PROJECT
```

```bash
gcloud config set project ${PROJECT_ID?}
```

## Pre-requisites

This tutorial requires that you have already deployed the Kubernetes App Launcher Operator in your GKE cluster.

If you have not already deployed the operator, follow this Cloud Shell tutorial to do so:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/solutions-k8s-stateful-workload-operator&cloudshell_git_branch=v1.0.0&cloudshell_tutorial=setup/README.md)

This tutorial requires that you have deployed the WebRTC streaming app launcher stack to the cluster.

If you have not installed the WebRTC stack, follow this Cloud Shell tutorial to do so:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/solutions-webrtc-gpu-streaming&cloudshell_git_branch=v1.0.0&&cloudshell_tutorial=tutorials/gke/00_Setup.md). 

## Platform verification

3. Obtain cluster credentials:

```bash
REGION=us-west1
```

> NOTE: change this to the region of your cluster.

```bash
gcloud --project ${PROJECT_ID?} container clusters get-credentials broker-${REGION?} --region ${REGION?}
```

2. Verify that the WebRTC streaming manifest bundle is present:

```bash
kubectl get configmap webrtc-gpu-streaming-manifests-1.4.0 -n pod-broker-system
```

3. Verify that GPU sharing is enabled:

```bash
kubectl describe node -l cloud.google.com/gke-accelerator-initialized=true | grep nvidia.com/gpu
```

Example output:

```
 nvidia.com/gpu:             48
 nvidia.com/gpu:             48
```

> Verify that the number of availble GPUs is greater than 1.

## Download dependencies

1. Copy your `Doom1.wad` to `images/brutal-doom/Doom1.wad`
2. Copy your `Doom2.wad` to `images/brutal-doom/Doom2.wad`
3. Download [Doom Metal Soundtrack](https://www.moddb.com/mods/brutal-doom/addons/doom-metal-soundtrack-v11) and save to `images/brutal-doom/doommetallost1.1.3.zip`
4. Download [Brutal Doom](https://www.moddb.com/mods/brutal-doom) and save to `images/brutal-doom/brutalv21.rar`

## Build the app image

1. Build the container image using cloud build:

```bash
(cd images && gcloud builds submit)
```

## Deploy the app manifests

1. Deploy manifests to the cluster:

```bash
gcloud builds submit --substitutions=_REGION=${REGION?}
```

2. Open the app launcher web interface and launch the app.

> NOTE: after the Cloud Build has completed from the previous step, it will take a few minutes for the nodes to pre-pull the image. As a result, the first launch may take longer than usual.
