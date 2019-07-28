#!/bin/sh

pushd ..

docker-compose -f ./yml/docker-compose.yml -f ./yml/docker-compose.build.yml build

popd