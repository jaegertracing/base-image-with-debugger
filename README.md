# Base Image with Debugger

This repository builds and publishes a base Docker image containing the [Delve](https://github.com/go-delve/delve) debugger. This image is intended to be used as a base for debugging Go applications in containers.

## Image Contents

- Alpine-based Go image
- `dlv` (Delve debugger) installed in `/go/bin/dlv`
- CA certificates and mime types

## Usage

You can use this image in your Dockerfiles:

```dockerfile
FROM ghcr.io/jaegertracing/base-image-with-debugger:latest
# ... your build steps ...
```

## Releases

The container image is only pushed on published GitHub Releases.

## Maintenance

The versions of the base image and Delve are managed by Renovate.

https://developer.mend.io/github/jaegertracing/base-image-with-debugger

## Local Development

You can build the image locally using the provided `Makefile`:

```bash
# Build for current architecture
make build

# Build for all supported architectures (requires Docker Buildx)
make build-all
```
