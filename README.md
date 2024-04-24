# Pixlet Docker Images

<!--renovate repo=tidbyt.dev/pixlet -->
[![Version](https://img.shields.io/badge/Version-v0.32.2-informational?style=flat)](https://github.com/gabe565/docker-pixlet/pkgs/container/pixlet)
[![Build](https://github.com/gabe565/docker-pixlet/actions/workflows/build.yml/badge.svg)](https://github.com/gabe565/docker-pixlet/actions/workflows/build.yml)

This repo builds Docker images for [tidbyt/pixlet](https://github.com/tidbyt/pixlet) to be used in containerized Pixlet runs.

The Pixlet version is automatically updated by Renovate bot, so new Pixlet releases will be available within a few hours.

## Images

- [ghcr.io/gabe565/pixlet](https://github.com/gabe565/docker-pixlet/pkgs/container/pixlet)

## Deployment

### Docker

See the included [`docker-compose.yml`](docker-compose.yml) for volume bind info. This would need to be run on a cron.

### Kubernetes

I am using this container in Kubernetes with a `CronJob` that runs minutely. I will post an example manifest soon.
