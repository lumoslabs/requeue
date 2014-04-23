# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rspec/autorun'
require 'fakeredis/rspec'

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'requeue'
