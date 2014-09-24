#!/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
cd $HOME/velocity/current

for TASK_NAME in "$@";
do
  RAILS_ENV=production bundle exec rake task:$TASK_NAME
done
