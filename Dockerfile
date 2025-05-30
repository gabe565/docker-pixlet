ARG PIXLET_REPO=tidbyt/pixlet
ARG PIXLET_VERSION=v0.34.0

FROM --platform=$BUILDPLATFORM golang:1.24.3-alpine AS go-dependencies
WORKDIR /go/src/github.com/tidbyt/pixlet

ARG PIXLET_REPO
ARG PIXLET_VERSION
RUN apk add --no-cache git
RUN set -x \
    && git clone -q \
    --config advice.detachedHead=false \
    --branch "$PIXLET_VERSION" \
    --depth 1 \
     "https://github.com/$PIXLET_REPO.git" . \
    && go mod download


FROM golang:1.24.3-alpine AS go-builder
WORKDIR /go/src/github.com/tidbyt/pixlet

RUN apk add --no-cache gcc g++ libwebp-dev

COPY --from=go-dependencies /go /go

ARG PIXLET_VERSION
RUN --mount=type=cache,target=/root/.cache \
    go install -ldflags="-s -w -X tidbyt.dev/pixlet/cmd.Version=$PIXLET_VERSION" -trimpath .


FROM alpine:3.22
LABEL org.opencontainers.image.source="https://github.com/gabe565/docker-pixlet"
WORKDIR /data

RUN apk add --no-cache tzdata libwebp-dev

ARG USERNAME=pixlet
ARG UID=1000
ARG GID=$UID
RUN addgroup -g "$GID" "$USERNAME" \
    && adduser -S -u "$UID" -G "$USERNAME" "$USERNAME"

COPY --from=go-builder /go/bin/pixlet /usr/bin

USER pixlet
