module Bioshogi
  module Formatter
    concern :YomiageFormatMethods do
      def to_yomiage(options = {})
        mediator.to_yomiage(options)
      end
    end
  end
end
