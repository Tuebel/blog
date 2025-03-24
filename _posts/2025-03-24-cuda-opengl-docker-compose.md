---
title: "CUDA and OpenGL using docker-compose"
description: "An example docker-compose.yml file with explanations"
layout: post
hide: false
tags: [julia, programming, wiki]
---

Every year or so, I try to set up Docker with an NVIDIA GPU with different capabilities.
Most of the tutorials seem to focus on the CUDA use case to serve the AI deep learning wave.
Posts on enabling CUDA and OpenGL in the same container are less frequent.


# Code and general notes
Below, you can find a docker-compose setup that currently works, which I use to make the [code from my Ph.D.](https://github.com/rwth-irt/BayesianPoseEstimation.jl/tree/main/.devcontainer) thesis more reproducible.
It is intended for devcontainers, so code is mounted into the container workspace.

```yml
services:
  cuda-opengl:
    build:
      dockerfile: .devcontainer/Dockerfile
      context: ..
    volumes:
      - ..:/home/vscode/workspace:cached
      # GUI support
      - /tmp/.X11-unix:/tmp/.X11-unix
    environment:
      # GUI support
      DISPLAY: $DISPLAY
      # Use NVIDIA GPU for rendering
      __NV_PRIME_RENDER_OFFLOAD: 1
      __GLX_VENDOR_LIBRARY_NAME: nvidia
      NVIDIA_DRIVER_CAPABILITIES: compute,utility,graphics,display
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    # Keep the container running so VS Code can attach
    tty: true
```

Most tutorials tell you how to enable CUDA or OpenGL in  `docker run`.
Using a docker-compose file makes things much clearer and more maintainable.

The original version from the link above includes some configurations that enable OpenGL in the Windows subsystem for Linux (WSL2).
At the time of writing, WSL2 does not support CUDA and OpenGL interop due to the Direct3D layer in between.

# CUDA support
First, you need a `Dockerfile` that is based on one of the `docker.io/nvidia/cuda` images.
Second, you need to [install the NVIDIA container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#).

In the docker-compose file, NVIDIA GPUs are added in the `deploy` section which mimicks `docker run --gpus all`.
Besides that, `NVIDIA_DRIVER_CAPABILITIES` enables CUDA via `compute` and tools like `nvidia-smi` via `utility`.

# OpenGL support
The first part is making the display available in the container.
We have to mount the X11 sockets in `/tmp/.X11-unix` and set the `DISPLAY` variable correctly.
Next, we have to make sure that the NVIDIA GPU is used for rendering to enable CUDA-OpenGL interop by setting `__NV_PRIME_RENDER_OFFLOAD` and `__GLX_VENDOR_LIBRARY_NAME`.
We also need to enable the corresponding `NVIDIA_DRIVER_CAPABILITIES` via `graphics` and `display`.
