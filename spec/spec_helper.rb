# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# require 'bioshogi'

require "bundler/setup"
require "bioshogi"
require "active_support/core_ext/benchmark"
require "fileutils"

ENV["BIOSHOGI_ENV"] = "test"

log_file = Pathname(__FILE__).dirname.join("../log/test.log").expand_path
FileUtils.makedirs(log_file.dirname)
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(log_file))

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
  config.expect_with :test_unit
  config.example_status_persistence_file_path = "_test.txt"
end

SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
