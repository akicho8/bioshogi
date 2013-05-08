module Bushido
  mattr_accessor :logger
  self.logger = ActiveSupport::BufferedLogger.new("/dev/null")
end
