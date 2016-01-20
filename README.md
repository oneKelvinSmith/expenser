# Expenser

Welcome to the Expenser. For expensing...

Try it out here: [https://expenser-of-awesome.herokuapp.com](https://expenser-of-awesome.herokuapp.com)

## Getting started

This is a Rails 4 API and an Ember 1.13 frontend.

Recommended setup:

* rails: 4.2.5
* ruby: 2.3.0
* postgres: 9.5.0

* ember: 1.13.13
* node: 5.4.1
* npm: 2.14.10
* os: darwin x64

To get up and running (after repo is cloned):

```bash
$ bundle install
$ rake ember:install
$ rake db:create
$ rake db:migrate

```

To run the web server locally [http://localhost:3000](http://localhost:3000):

```bash
$ bundle exec foreman start -f Procfile.dev

```

To run the specs:

```bash
$ bundle exec rspec

```
