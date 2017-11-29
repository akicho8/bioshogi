module Bushido
  extend ActiveSupport::Concern

  concern :ApplicationMemoryRecord do
    included do
      include MemoryRecord
    end

    def fetch(*)
      super
    rescue => error
      raise BushidoError, error.message
    end
  end
end
