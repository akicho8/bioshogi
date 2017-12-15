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

    def name
      key.to_s
    end

    def <=>(other)
      [other.class, code] <=> [other.class, other.code]
    end

    def eql?(other)
      self.class == other.class && key == other.key
    end
  end
end
