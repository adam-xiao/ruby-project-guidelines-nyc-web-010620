require_relative '../config/environment'

require 'pry'
require 'rest-client'
require 'tty-prompt'

prompt =  TTY::Prompt.new


system("#{ENV["API_KEY"]}")
