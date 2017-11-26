# -*- frozen-string-literal: true -*-

module Bushido
  mattr_accessor(:logger) { ActiveSupport::Logger.new("/dev/null") }
end
