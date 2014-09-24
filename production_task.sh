#!/bin/bash

source $HOME/.rvm/environments/velocity

for TASK_NAME in "$@";
do
  RAILS_ENV=production bundle exec rake task:$TASK_NAME
done