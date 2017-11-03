module Bushido
  mattr_accessor(:logger) { ActiveSupport::Logger.new("/dev/null") }
end
