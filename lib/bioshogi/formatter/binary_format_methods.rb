module Bioshogi
  module Formatter
    concern :BinaryFormatMethods do
      def image_renderer(options = {})
        ImageRenderer.new(mediator, options)
      end

      def to_image(options = {})
        image_renderer(options).to_blob_binary
      end

      ################################################################################

      def to_png(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "png")).to_blob_binary
      end

      def to_jpg(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "jpg")).to_blob_binary
      end

      def to_gif(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "gif")).to_blob_binary
      end

      ################################################################################

      def to_mp4(options = {})
        Mp4Builder.new(self, options).to_binary
      end

      def to_animation_gif(options = {})
        AnimationGifBuilder.new(self, options).to_binary
      end

      def to_animation_png(options = {})
        AnimationPngBuilder.new(self, options).to_binary
      end

      def to_animation_webp(options = {})
        AnimationWebpBuilder.new(self, options).to_binary
      end

      def to_animation_zip(options = {})
        AnimationZipBuilder.new(self, options).to_binary
      end
    end
  end
end
