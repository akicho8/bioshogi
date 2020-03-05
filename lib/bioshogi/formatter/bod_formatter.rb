# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :BodFormatter do
      def to_bod(**options)
        mediator.to_bod(**options)
      end
    end
  end
end
