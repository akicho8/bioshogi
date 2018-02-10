# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# require 'warabi'

require "bundler/setup"
require "warabi"

ENV["WARABI_ENV"] = "test"

log_file = Pathname(__FILE__).dirname.join("../log/test.log").expand_path
FileUtils.makedirs(log_file.dirname)
Warabi.logger = ActiveSupport::Logger.new(log_file)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :minitest
end
