require "bioshogi"
require "active_support/core_ext/benchmark"
require "fileutils"
require "pp"
require "yaml"

# 標準出力キャプチャ用
# capture(:stdout) { print "x" } # => "x"
if true
  require "tempfile"
  require "active_support/testing/stream"
  include ActiveSupport::Testing::Stream
end

log_file = Pathname("#{__dir__}/../log/test.log")
FileUtils.makedirs(log_file.dirname)
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(log_file))

require "simplecov"
SimpleCov.start

Pathname.glob("#{__dir__}/**/*_support.rb") { |e| require e.to_s }
Pathname.glob("#{__dir__}/support/**/*.rb") { |e| require e.to_s }

Zeitwerk::Loader.eager_load_all

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :test_unit
  config.example_status_persistence_file_path = "#{__dir__}/_all_test_result.txt"
  config.expose_dsl_globally = false # false: グローバルに RSpec 関連メソッドをぶちまけない

  if ENV["ORDER_DEFINED"]
    config.order = :defined
  end
end
