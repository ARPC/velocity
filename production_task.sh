#!/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
rvm use velocity

for TASK_NAME in "$@";
do
  RAILS_ENV=production bundle exec rake task:$TASK_NAME
done
