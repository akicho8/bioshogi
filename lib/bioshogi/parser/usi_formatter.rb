module Bioshogi
  module Parser
    concern :UsiFormatter do
      def to_sfen(**options)
        mediator.to_sfen(options)
      end
    end
  end
end
