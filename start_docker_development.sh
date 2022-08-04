#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid
echo > log/development.log
echo > log/test.log
bundle exec rails s -p 3000 -b '0.0.0.0'
