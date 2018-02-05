module Warabi
  module Parser
    concern :UsiSerializer do
      def to_sfen(**options)
        mediator.to_sfen(options)
      end
    end
  end
end
