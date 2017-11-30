module Bushido
  extend ActiveSupport::Concern

  concern :ApplicationMemoryRecord do
    included do
      include MemoryRecord
    end

    class_methods do
      def fetch(*)
        super
      rescue KeyError => error
        raise BushidoError, error.message
      end
    end

    def name
      key.to_s
    end
  end
end
