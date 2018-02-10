module Warabi
  extend ActiveSupport::Concern

  concern :ApplicationMemoryRecord do
    included do
      include MemoryRecord

      def self.fetch(*)
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
