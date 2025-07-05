# frozen-string-literal: true

module Bioshogi
  module SimpleModel
    def initialize(attributes)
      attributes.each do |k, v|
        send("#{k}=", v)
      end

      super()
    end
  end
end
