module Bioshogi
  module Formatter
    concern :SafenFormatter do
      def to_sfen(**options)
        mediator.to_sfen(options)
      end
    end
  end
end
