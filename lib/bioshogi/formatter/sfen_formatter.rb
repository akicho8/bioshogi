module Bioshogi
  module Formatter
    concern :SfenFormatter do
      def to_sfen(**options)
        mediator.to_sfen(**options)
      end
    end
  end
end
