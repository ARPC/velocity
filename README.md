velocity
========

velocify!

Getting Setup
-------------

* Install XCode
* Install XCode Command tools
  * `xcode-select --install`
* Install [PostGres app](http://postgresapp.com/)
* Install PG Bundle
  * `bundle config build.pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
 ARCHFLAGS="-arch x86_64" gem install pg1`
* Create a role/user
  * Use name/password from config/database.yml
```sql
create role your-database-user-name with createdb login password 'your-database-password';
```
* Clone (or fork) the repository.
* Setup the ruby environment
  * `rvm install ruby-2.1.2` (if necessary)
  * `bundle`
* Configure the project
  * copy the `config/secrets_sample.yml` file to `config/secrets.yml`
  * generate a secret key using `rake secret`
* create a file config/lean_kit_kanban.rb with your user credentials

```ruby
LeanKitKanban::Config.email = "your-email@address.com"
LeanKitKanban::Config.password = "your-password"
LeanKitKanban::Config.account = "your-account"
```
* modify boards and lanes in config/initializers/lean_kit_kanban_configs.rb
* Confirm the project works
  * `rspec`

* You are done when all of the specs pass.

* Processes done cards to support velocity calculations
  * `rake task:process_done`

* Send out email notifications
  * Notify the team about all the cards that are missing estimates
    * `rake notifiy:no_estimates`
  * Notify the team about all the cards that are missing estimates
    * `rake notify:no_shepherds`
  * Provide an extract of every card and its lane
    * `rake notify:extract`
