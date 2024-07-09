FROM --platform=$BUILDPLATFORM golang:1.22.5-alpine AS go-dependencies
WORKDIR /app

ARG PIXLET_REPO=tidbyt/pixlet
ARG PIXLET_VERSION=v0.33.3
RUN apk add --no-cache git
RUN set -x \
    && git clone -q \
    --config advice.detachedHead=false \
    --branch "$PIXLET_VERSION" \
    --depth 1 \
     "https://github.com/$PIXLET_REPO.git" . \
    && go mod download


FROM golang:1.22.5-alpine as go-builder
WORKDIR /app

RUN apk add --no-cache gcc g++ libwebp-dev

COPY --from=go-dependencies /app .
COPY --from=go-dependencies /go /go

RUN --mount=type=cache,target=/root/.cache \
    go build -ldflags='-s -w' -o pixlet


FROM alpine:3.20
LABEL org.opencontainers.image.source="https://github.com/gabe565/docker-pixlet"
WORKDIR /data

RUN apk add --no-cache tzdata libwebp-dev

ARG USERNAME=pixlet
ARG UID=1000
ARG GID=$UID
RUN addgroup -g "$GID" "$USERNAME" \
    && adduser -S -u "$UID" -G "$USERNAME" "$USERNAME"

COPY --from=go-builder /app/pixlet /usr/bin

USER pixlet
