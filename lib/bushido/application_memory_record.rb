module Bushido
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

    def <=>(other)
      [other.class, code] <=> [other.class, other.code]
    end
  end
end
