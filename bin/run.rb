require_relative '../config/environment'


prompt =  TTY::Prompt.new

prompt.multi_select("What do you want to do?", ["Look up User","opt2","opt3","opt4"])

system("#{ENV["API_KEY"]}")


