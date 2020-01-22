require 'dotenv/load'
require 'rest-client'
require 'tty-prompt'
require 'bundler'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'app'


# api_key = "RGAPI-629f042a-e649-4f07-8766-1881bbb4fb8d"
