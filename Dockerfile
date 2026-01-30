# Copyright (c) 2025 The Jaeger Authors.
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.25.6-alpine@sha256:98e6cffc31ccc44c7c15d83df1d69891efee8115a5bb7ede2bf30a38af3e3c92 AS build
ARG TARGETARCH
ENV GOPATH=/go
RUN apk add --update --no-cache ca-certificates make git build-base mailcap

WORKDIR /go/src/debug-delve
COPY go.mod go.sum /go/src/debug-delve/

# TODO: Remove s390x once go-delve adds support for it (https://github.com/go-delve/delve/issues/2883)
# TODO: Remove ppc64le once support is released (https://github.com/go-delve/delve/issues/1564)
RUN if [[ "$TARGETARCH" == "s390x" ||  "$TARGETARCH" == "ppc64le" ]] ; then \
        echo '#!/bin/bash' > /go/bin/dlv; \
        echo 'echo Delve not supported on the current architecture' >> /go/bin/dlv; \
        chmod a+x /go/bin/dlv; \
    else \
        cd /go/src/debug-delve && \
        go mod download && \
        go build -o /go/bin/dlv github.com/go-delve/delve/cmd/dlv; \
    fi

FROM golang:1.25.6-alpine@sha256:98e6cffc31ccc44c7c15d83df1d69891efee8115a5bb7ede2bf30a38af3e3c92
COPY --from=build /go/bin/dlv /go/bin/dlv
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /etc/mime.types /etc/mime.types
