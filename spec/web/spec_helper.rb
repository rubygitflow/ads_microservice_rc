require_relative '../coverage_helper'
ENV["RACK_ENV"] = "test"
require_relative '../../app'
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?('test')

Gem.suffix_pattern

require_relative '../minitest_helper'

AdsMicroservice.plugin :not_found do
  raise "404 - File Not Found"
end
AdsMicroservice.plugin :error_handler do |e|
  raise e
end
