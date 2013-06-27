module Bushido
  mattr_accessor :logger
  self.logger = ActiveSupport::Logger.new("/dev/null")
end
