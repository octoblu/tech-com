#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)
export DNS="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"

echo + rabbitmq
docker-compose build
docker-compose up
