# README

[![Ruby](https://github.com/douglasfeitosa/invoice_manager/actions/workflows/ruby.yml/badge.svg)](https://github.com/douglasfeitosa/invoice_manager/actions/workflows/ruby.yml)

Invoice Manager is an app that creates and send invoices to a list of emails.

In order to run the project, you need:

* Ruby version

  * 2.6.0

* System dependencies

  * Install postgresql 

* Configuration

  * After install ruby, install bundler gem and run bundle install 
  
* Database creation

  * bundle exec rails db:setup 

* Database initialization

  * bundle exec rails db:seed 

* How to run the test suite

    * bundle exec rspec spec
