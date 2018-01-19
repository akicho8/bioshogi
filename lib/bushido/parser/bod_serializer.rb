# frozen-string-literal: true

module Bushido
  module Parser
    concern :BodSerializer do
      def to_bod(**options)
        mediator.to_bod(options)
      end
    end
  end
end
