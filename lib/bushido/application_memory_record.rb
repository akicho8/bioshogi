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
    def name
      key.to_s
    end
  end
end
