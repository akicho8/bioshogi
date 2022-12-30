module Bioshogi
  module Container
    class << self
      def create(*args)
        Basic.new(*args)
      end
    end
  end
end
