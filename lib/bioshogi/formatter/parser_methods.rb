# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :ParserMethods do
      included do
        FORMATTER_METHODS = [
          :container,
          :to_kif,
          :to_ki2,
          :to_csa,
          :to_sfen,
          :to_bod,
          :to_yomiage,
          :to_yomiage_list,
          :to_akf,
          :screen_image_renderer,
          :to_image,
          :to_png,
          :to_jpg,
          :to_gif,
          :to_webp,
          :to_animation_mp4,
          :to_animation_gif,
          :to_animation_apng,
          :to_animation_webp,
          :to_animation_zip,
        ].freeze
        delegate(*FORMATTER_METHODS, to: :formatter)
      end

      def formatter
        @formatter ||= Core.new(pi, parser_options)
      end
    end
  end
end
