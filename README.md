# README

[![Ruby](https://github.com/douglasfeitosa/invoice_manager/actions/workflows/ruby.yml/badge.svg)](https://github.com/douglasfeitosa/invoice_manager/actions/workflows/ruby.yml)

Invoice Manager is an app that creates and send invoices to a list of emails.

In order to run the project, you need:

* Ruby version
  * `2.6.0`

* System dependencies
  * `Postgresql`
  * `Redis`

* Configuration
  * Run `bundle install` in app folder
  * Copy .env.example in .env file
  * You need a gmail account to send e-mail
    * Replace values in `SMTP_USERNAME` and `SMTP_PASSWORD`
  * You need allow apps to your account and do not have 2 factor authentication
    * See more `https://myaccount.google.com/lesssecureapps`
  
* Database creation
  * `bundle exec rails db:setup`

* Database initialization
  * `bundle exec rails db:seed` 

* How to run the test suite
  * `bundle exec rspec spec`

* How to run project
  * Run `redis-server` in terminal
  * Run `bundle exec sidekiq` in another terminal
  * Run `rails s -p 3000` to start server