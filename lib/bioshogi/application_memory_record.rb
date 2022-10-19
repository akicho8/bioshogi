module Bioshogi
  extend ActiveSupport::Concern

  concern :ApplicationMemoryRecord do
    included do
      include MemoryRecord

      def self.fetch(*)
        super
      rescue KeyError => error
        raise KeyNotFound, error.message
      end

      # fetch できなかったとき default_key が指すレコードを返す
      def self.safe_fetch(key)
        v = lookup(key)
        if !v
          v = fetch(default_key)
        end
        v
      end
    end

    def inspect
      "<#{key}>"
    end
  end
end
