require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] = "test"
require 'action_controller'
module Rails
  module VERSION
    MAJOR = 2
  end
end unless defined? Rails
RAILS_ROOT = './' unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)

require "simple_navigation_renderers"