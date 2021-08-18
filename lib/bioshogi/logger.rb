# frozen-string-literal: true
require "active_support/tagged_logging"

module Bioshogi
  mattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(File::NULL)) }
end
