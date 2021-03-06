#!/bin/bash

set -e

if [[ "$USER" != "http" ]]; then
	echo "Should be run as http"
	exit 1
fi

cd /var/www/gamocosm

git checkout release
git pull origin release

# TODO rvm set for non-default case
bundle install
RAILS_ENV=production ./run.sh --bundler rake assets:precompile
RAILS_ENV=production ./run.sh --bundler rake db:migrate
RAILS_ENV=test ./run.sh rake db:migrate
./run.sh rake db:migrate

TIMESTAMP="$(date +'%Y_%m_%d-%H:%M')"
mkdir -p log/archive
[ -e log/production.log ] && mv log/production.log "log/archive/production.$TIMESTAMP.log"
[ -e log/sidekiq.log ] && mv log/sidekiq.log "log/archive/sidekiq.$TIMESTAMP.log"

touch tmp/restart.txt

echo "Remember to restart the Gamocosm Sidekiq service!"
