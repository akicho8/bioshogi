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
      code <=> other.code
    end
  end
end
