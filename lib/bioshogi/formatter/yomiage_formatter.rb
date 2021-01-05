module Bioshogi
  module Formatter
    concern :YomiageFormatter do
      def to_yomiage(options = {})
        mediator.to_yomiage(options)
      end
    end
  end
end
