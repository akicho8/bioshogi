module Bioshogi
  module Formatter
    concern :PngFormatter do
      def to_png(options = {})
        image_formatter(options).to_png
      end

      def to_blob(options = {})
        image_formatter(options).to_blob
      end

      def image_formatter(options = {})
        ImageFormatter.render(self, options)
      end
    end
  end
end
