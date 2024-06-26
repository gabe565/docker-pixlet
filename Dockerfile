ARG PIXLET_PACKAGE=tidbyt.dev/pixlet
ARG PIXLET_VERSION=v0.33.3

FROM golang:1.22-alpine as go-builder

RUN apk add --no-cache gcc g++ libwebp-dev

ARG PIXLET_PACKAGE
ARG PIXLET_VERSION
RUN --mount=type=cache,target=/root/.cache \
    go install -ldflags='-s -w' "$PIXLET_PACKAGE@$PIXLET_VERSION"


FROM alpine:3.20
LABEL org.opencontainers.image.source="https://github.com/gabe565/docker-pixlet"
WORKDIR /data

RUN apk add --no-cache tzdata libwebp

ARG USERNAME=pixlet
ARG UID=1000
ARG GID=$UID
RUN addgroup -g "$GID" "$USERNAME" \
    && adduser -S -u "$UID" -G "$USERNAME" "$USERNAME"

COPY --from=go-builder /go/bin/pixlet /usr/bin

USER pixlet
