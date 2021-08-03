module Bioshogi
  module Formatter
    concern :BinaryFormatMethods do
      def to_image_blob(options = {})
        image_formatter(options).to_blob
      end

      def image_formatter(options = {})
        ImageFormatter.render(mediator, options)
      end
    end
  end
end
