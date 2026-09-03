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

## Upgrading for a New Go Release

Delve refuses to attach to a binary built by a newer Go than it knows about, so a project moving to a new Go release needs a matching Delve release here first. Where the consumer's own tests run its debug image, as Jaeger's all-in-one integration test does, that mismatch fails CI rather than merely degrading the debugger.

1. Look for open Renovate pull requests before writing anything. Renovate tracks both `github.com/go-delve/delve` and the `golang` image, so the bump is often already waiting, and merging that pull request is better than opening one that supersedes it. Otherwise bump both by hand and merge the change, remembering that the `golang` image appears twice in the `Dockerfile`, once for the build stage and once for the runtime stage. [#19](https://github.com/jaegertracing/base-image-with-debugger/pull/19), the Go 1.27 upgrade, is a worked example: both `FROM` lines, the `delve` requirement, and the module's own `go` directive.
2. Publish a GitHub release, and the release workflow will push the image to GHCR.
3. Repoint the consuming project at the new image, pinning the tag together with its digest.

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
