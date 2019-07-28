#!/bin/sh

docker-compose -f ./yml/docker-compose.yml -f ./yml/docker-compose.dev.yml -f ./yml/docker-compose.build.yml up "$@"
