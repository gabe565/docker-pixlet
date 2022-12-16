ARG GO_VERSION=1.19
ARG PIXLET_VERSION=v0.22.8

FROM golang:$GO_VERSION-alpine as go-builder

RUN apk add --no-cache gcc g++ libwebp-dev

ARG PIXLET_VERSION
RUN --mount=type=cache,target=/root/.cache \
    go install "tidbyt.dev/pixlet@$PIXLET_VERSION"


FROM alpine
LABEL org.opencontainers.image.source="https://github.com/gabe565/docker-pixlet"
WORKDIR /app

RUN apk add --no-cache tzdata libwebp

ARG USERNAME=pixlet
ARG UID=1000
ARG GID=$UID
RUN addgroup -g "$GID" "$USERNAME" \
    && adduser -S -u "$UID" -G "$USERNAME" "$USERNAME"

COPY --from=go-builder /go/bin/pixlet /usr/bin

USER pixlet
