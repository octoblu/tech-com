#!/bin/sh
cd $(dirname $0)
set -eE

sudo sysctl -w kern.ipc.somaxconn=4096

#brew install
brew update
for package in dnsmasq docker docker-machine docker-compose; do
  brew unlink $package
  brew install $package
  brew link --overwrite $package
done

#dnsmasq
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -p /etc/resolver
sudo cp ../services-core/dnsmasq/resolver-dev /etc/resolver/dev
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
(cd ../services-core/dnsmasq; ./setup.sh 127.0.0.1 127.0.0.1)
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

MIN_COMPOSE_VER=1.6
COMPOSE_VER=$(docker-compose --version | grep -oE '([0-9]+\.[0-9]+)')
if ! echo $COMPOSE_VER $MIN_COMPOSE_VER | awk '{exit $1>=$2?0:1}'; then
  echo  $'\n'$'`docker-compose --version`'$" of $COMPOSE_VER should be >= $MIN_COMPOSE_VER"$'\n' \
        $'... good luck!'$'\n' \
        $'   ¯\_(ツ)_/¯'
  exit 1
fi

MIN_NODE_VER=5
NODE_VER=$(node --version | grep -oE '([0-9]+\.[0-9]+)')
if ! echo $NODE_VER $MIN_NODE_VER | awk '{exit $1>=$2?0:1}'; then
  echo  $'\n'$'`node --version`'$" of $NODE_VER should be >= $MIN_NODE_VER"$'\n' \
        $'... try `nvm use '$"$MIN_NODE_VER"$'`?'$'\n' \
        $'   ¯\_(ツ)_/¯'
  exit 1
fi

#node
npm install --global growl-express
