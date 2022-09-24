# frozen_string_literal: true
require_relative 'coverage_helper'
ENV["RACK_ENV"] = "test"
require_relative '../models'
require_relative '../app'
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?('test')

require 'capybara'
require 'capybara/dsl'
require 'rack/test'

Gem.suffix_pattern

Sequel::Model.freeze_descendents
DB.freeze

require_relative 'minitest_helper'

Capybara.app = AdsMicroservice.freeze.app
Capybara.exact = true

class Minitest::HooksSpec
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    Capybara.app
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
