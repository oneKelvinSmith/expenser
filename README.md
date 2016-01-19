# Expenser

## Getting started

Recommended setup:

Rails
version: 4.2.5
ruby: 2.3.0

Ember
version: 1.13.13
node: 5.4.1
npm: 2.14.10
os: darwin x64

This is a Rails 4 API and an Ember 1.13 frontend.

To get up and running (was repo is cloned):

```bash
$ bundle install
$ rake ember:install
$ rake db:create
$ rake db:migrate

```

To run the web server locally [http://localhost:3000](http://localhost:3000):

```bash
$ bundle exec foreman start

```

To run the specs:

```bash
$ bundle exec rspec

```
