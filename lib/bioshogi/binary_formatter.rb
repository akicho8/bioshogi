module Bioshogi
  class BinaryFormatter
    class << self
      def render(*args)
        new(*args).tap(&:render)
      end
    end
  end
end
