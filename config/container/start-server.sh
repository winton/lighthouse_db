#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh
bundle exec rake db:migrate
bundle exec unicorn -D -p 8080
nginx
