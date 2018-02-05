# frozen-string-literal: true

module Warabi
  mattr_accessor(:logger) { ActiveSupport::Logger.new("/dev/null") }
end
