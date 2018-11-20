require 'simplecov'
SimpleCov.start

SimpleCov.start do
  add_filter "/test/"
  add_filter "/lib/version.rb"
end

require "minitest/autorun"
require_relative "../lib/rks"
