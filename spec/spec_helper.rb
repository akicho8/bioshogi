# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# require 'warabi'

require "bundler/setup"
require "warabi"

ENV["WARABI_ENV"] = "test"

log_file = Pathname(__FILE__).dirname.join("../log/test.log").expand_path
FileUtils.makedirs(log_file.dirname)
Warabi.logger = ActiveSupport::Logger.new(log_file)

# Traceback (most recent call last):
#       11: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-0.16.1/lib/simplecov/defaults.rb:27:in `block in <top (required)>'
#       10: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-0.16.1/lib/simplecov.rb:200:in `run_exit_tasks!'
#        9: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-0.16.1/lib/simplecov/configuration.rb:182:in `block in at_exit'
#        8: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-0.16.1/lib/simplecov/result.rb:48:in `format!'
#        7: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-html-0.10.2/lib/simplecov-html.rb:22:in `format'
#        6: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-html-0.10.2/lib/simplecov-html.rb:22:in `open'
#        5: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/simplecov-html-0.10.2/lib/simplecov-html.rb:23:in `block in format'
#        4: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/2.5.0/erb.rb:885:in `result'
#        3: from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/2.5.0/erb.rb:885:in `eval'
#        2: from (erb):35:in `block in format'
#        1: from (erb):35:in `each'
# (erb):36:in `block (2 levels) in format': incompatible character encodings: UTF-8 and ASCII-8BIT (Encoding::CompatibilityError)
#
# となるためコメントアウト
#
# require 'simplecov'
# SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :minitest
end
