module Bioshogi
  module Formatter
    concern :BinaryFormatMethods do
      def image_formatter(options = {})
        ImageFormatter.new(mediator, options)
      end

      def to_image(options = {})
        image_formatter(options).to_blob_binary
      end

      ################################################################################

      def to_png(options = {})
        ImageFormatter.new(mediator, options.merge(image_format: "png")).to_blob_binary
      end

      def to_jpg(options = {})
        ImageFormatter.new(mediator, options.merge(image_format: "jpg")).to_blob_binary
      end

      def to_gif(options = {})
        ImageFormatter.new(mediator, options.merge(image_format: "gif")).to_blob_binary
      end

      ################################################################################

      def to_mp4(options = {})
        Mp4Formatter.new(self, options).to_binary
      end

      def to_animation_gif(options = {})
        AnimationGifFormatter.new(self, options).to_binary
      end

      def to_animation_png(options = {})
        AnimationPngFormatter.new(self, options).to_binary
      end

      def to_animation_webp(options = {})
        AnimationWebpFormatter.new(self, options).to_binary
      end

      def to_animation_zip(options = {})
        AnimationZipFormatter.new(self, options).to_binary
      end
    end
  end
end
