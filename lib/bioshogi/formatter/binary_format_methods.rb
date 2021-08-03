module Bioshogi
  module Formatter
    concern :BinaryFormatMethods do
      def image_formatter(options = {})
        ImageFormatter.render(mediator, options)
      end

      def to_image(options = {})
        image_formatter(options).to_blob
      end

      def animation_format(options = {})
        AnimationFormatter.render(self, options)
      end

      def to_animation(options = {})
        animation_format(options).to_blob
      end
    end
  end
end
