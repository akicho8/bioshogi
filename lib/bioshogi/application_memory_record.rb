module Bioshogi
  extend ActiveSupport::Concern

  concern :ApplicationMemoryRecord do
    included do
      unless self < MemoryRecord
        include MemoryRecord
      end

      def self.fetch(...)
        super
      rescue KeyError => error
        raise KeyNotFound, error.message
      end
    end

    def inspect
      "<#{key}>"
    end
  end
end
