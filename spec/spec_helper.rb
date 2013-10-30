require 'bundler'
Bundler.setup

require 'minitest/spec'
require 'minitest/autorun'

require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'action_view/helpers'

require 'nokogiri'

$:.unshift File.expand_path('../lib', __FILE__)
require 'tabula_rasa'

require 'config/active_record'
require 'config/spec'
