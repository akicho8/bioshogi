# frozen-string-literal: true

module Bioshogi
  module SimpleModel
    def initialize(attributes)
      attributes.each do |k, v|
        public_send("#{k}=", v)
      end

      super()
    end
  end
end
