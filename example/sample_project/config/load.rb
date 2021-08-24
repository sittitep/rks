# require 'rubygems'
require 'bundler/setup'
# require 'benchmark'

Bundler.require(:default)

# Dir[File.join(".", "lib", "*.rb")].each { |f| require f }

require_relative "application.rb"

Dir[File.join(".", "app", "**","*.rb")].each { |f| require f }

# require "./config/initialize.rb"
