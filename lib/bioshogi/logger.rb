# frozen-string-literal: true

module Bioshogi
  mattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(File::NULL)) }
end
