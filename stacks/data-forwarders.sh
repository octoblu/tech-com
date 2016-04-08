#!/usr/bin/env bash

eval $(docker-machine env --shell=bash octoblu-dev)
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='channel-device'
RUN_SERVICE="run-service-docker.sh"

while getopts ":l" opt; do
  case $opt in
    l)
      RUN_SERVICE="run-service-local.sh"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES
tmux set-environment -t $SESSION DOCKER_CERT_PATH $DOCKER_CERT_PATH
tmux set-environment -t $SESSION DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
tmux set-environment -t $SESSION DOCKER_HOST $DOCKER_HOST
tmux set-environment -t $SESSION DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME
tmux set-environment -t $SESSION RUN_SERVICE $RUN_SERVICE

tmux new-window -t $SESSION:1 -n data-forwarders
tmux new-window -t $SESSION:2 -n event-collector

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/data-forwarders" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE data-forwarders" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/meshblu-splunk-event-collector" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE meshblu-splunk-event-collector" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
