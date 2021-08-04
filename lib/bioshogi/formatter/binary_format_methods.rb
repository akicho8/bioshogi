module Bioshogi
  module Formatter
    concern :BinaryFormatMethods do
      def image_formatter(options = {})
        ImageFormatter.render(mediator, options)
      end

      def to_image(options = {})
        image_formatter(options).to_blob_binary
      end

      def animation_formatter(options = {})
        AnimationFormatter.render(self, options)
      end

      def to_animation(options = {})
        animation_formatter(options).to_blob_binary
      end
    end
  end
end
