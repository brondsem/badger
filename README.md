# Badger Badger Badger

The Badge Making App

# Setup

Have postgresql up and running, or edit config/database.yml

```
rbenv init
# which tells you to run:
#     eval "$(rbenv init -)"
rbenv install 2.2.2
rbenv local 2.2.2
gem install bundler
bundle install
psql postgres
  CREATE DATABASE "badger-development";
bin/rake db:migrate RAILS_ENV=development 
```

# Running

```
bundle exec rails server
```
Go to http://localhost:3000/

# Usage

Create account
Go to http://localhost:3000/events/new
Create a role.  Color should be hex, like: `FF0000`

# Import CSV

See `app/interactor/import_attendees.rb` for CSV format details, but basically have a CVS with columns:

* first-name
* last-name
* email
* twitter
* role (or will default to first role)

After generating badges once, they'll be marked as exported already and not get exported again.
