module Bioshogi
  class ImageFormatter
    concerning :Helper do
      included do
        default_params.update({
          })
      end

      def roundrectangle2(g, v)
        size = V.one
        v1 = v + size * -0.5
        v2 = v + size * +0.5
        g.roundrectangle(*px(v1), *px(v2), *(cell_rect * 0.25))
      end

      private

      def d(image)
        file = Bundler.root.join("_tmp/#{SecureRandom.hex}.png").expand_path
        FileUtils.makedirs(file.dirname)
        image.write(file)
        `open #{file}`
      end
    end
  end
end
