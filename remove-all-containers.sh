#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)
docker rm -f $(docker ps -a -q)
