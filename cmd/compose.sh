#!/bin/sh
./cmd/base.sh \
  -f ./docker/build.yml \
  -f ./docker/dev.yml \
  $@
