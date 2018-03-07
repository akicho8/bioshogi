# frozen-string-literal: true

module Warabi
  module SimpleModel
    def initialize(attributes)
      attributes.each do |k, v|
        public_send("#{k}=", v)
      end

      super()
    end
  end
end
