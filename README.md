velocity
========

velocify!

Getting Setup
-------------

* Install XCode
* Install XCode Command tools - ( xcode-select --install )
* Install PostGres app ( http://postgresapp.com/ )
* Install PG Bundle
** bundle config build.pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
** ARCHFLAGS="-arch x86_64" gem install pg
* Create a role/user
** create role dev with createdb login password '******';
* Clone (or fork) the repository.
* `rvm install ruby-2.1.2` (if necessary)
* `bundle`
* copy the `config/secrets_sample.yml` file to `config/secrets.yml`
* generate a secret key using `rake secret`
* Run `rspec`
* Setup board id in lib/kanban/api.rb
* create a file config/lean_kit_kanban.rb with your user credentials

LeanKitKanban::Config.email = "your-email@address.com"
LeanKitKanban::Config.password = "your-password"
LeanKitKanban::Config.account = "your-account"

* You are done when all of the specs pass.
