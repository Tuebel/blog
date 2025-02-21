---
title: "Julia Startup Mods"
description: "Loading packages and enabling OpenGL at startup"
layout: post
toc: false
hide: false
tags: [julia, programming, wiki]
---

Using `startup.jl` I load packages like `OhMyREPL` and `Revise` which make the Julia REPL and IDE more enjoyable.
Moreover, I have a script for enabling OpenGL with CUDA interop on headless servers and another for hardware-accelerated OpenGL on WSL.

## startup.jl
Located at `~/.julia/config/startup.jl`, is where I load useful packages that I always want to be available in the REPL and IDE.

```julia
# Nice Syntax higlighting
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end
end
# Automatic recompilation of developed package
using Revise
# Showing images in VSCode
using ImageShow
```

## OpenGL with CUDA interop on remote servers
I use this one with VirtualGL, so Julia can call OpenGL on headless servers that do not have a display attached.

```sh
#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
JULIA=$DIR/julia
# VSCode reads the ouputs of julia -e using Pkg; println.(Pkg.depots())
# echo "Julia with OpenGL support via VirtualGL, executable: $JULIA"
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia DISPLAY=:0 vglrun $JULIA "$@"
# If you want to use TurboVNC with :1 instead of :0
# /opt/TurboVNC/bin/vncserver :1
# __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia DISPLAY=:1 vglrun $JULIA "$@"
```

It is crucial that the full path to the Julia executable is provided.
This script solves it by being located in the same directory as the Julia executable.
You might as well hard-code the absolute path to the executable.

Make this file executable via `chmod +x julia-opengl.sh` and copy it to the directory which contains the Julia executable.
Then trick **VSCode** into thinking that this file is the Julia executable:
```json
"julia.executablePath": "/path/to/julia/bin/julia-opengl.sh"
```

## OpenGL on WSL
WSLg enables using hardware-accelerated OpenGL rendering on the Windows Subsystem for Linux.
Make sure to install a recent driver for your GPU.
On recent Ubuntu distros (>22.04) it should work out of the box; older distros need a PPA (e.g. kisak-mesa) to install a recent mesa version.

> However, using the Direct3D12 backend for OpenGL only enables OpenGL 4.2.
> My [SciGL.jl](https://github.com/rwth-irt/SciGL.jl) package requires OpenGL 4.5 for persistent texture mapping and `glGetTextureSubImage`.
> Using the kisak-mesa PPA, I was able to get OpenGL 4.6 with LLVMpipe but no hardware acceleration. 

> OpenGL-**CUDA interop** is [not supported on WSL](https://docs.nvidia.com/cuda/wsl-user-guide/index.html#features-not-yet-supported)!


```sh
#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
JULIA=$DIR/julia
# WSL requires another environment variable for rendering on the NVIDIA GPU
MESA_D3D12_DEFAULT_ADAPTER_NAME=Nvidia $JULIA "$@"
```

Similar to the server version above, copy the file to the directory which contains the Julia executable, make it executable, and trick **VSCode** into thinking that this file is the Julia executable.