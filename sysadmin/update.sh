#!/bin/bash

set -e

cd /var/www/gamocosm

git pull origin master

RAILS_ENV=production bundle exec rake assets:precompile

touch tmp/restart.txt
