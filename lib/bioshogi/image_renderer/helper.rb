require "tempfile"
require "securerandom"

module Bioshogi
  module ImageRenderer
    concern :Helper do
      # 最後の render の結果を保持するバージョン
      # animation_mp4_builder, animation_gif_builder だけで使っている
      begin
        attr_reader :last_rendered_image

        def next_build
          @last_rendered_image = render
        end
      end

      def display
        d(render)
      end

      # png や gif は問題ないが apng や mp4 の場合に失敗する → ImageList#format に設定しているせいっぽい
      # そもそも画像リストを write("foo.png") にすると foo-0.png foo-1.png などと複数生成されるのだから
      # write は拡張子に合わせて format を設定して to_blob の結果を write しているのではないことがわかる
      def to_blob_binary
        image = render
        image.format = ext_name
        image.to_blob
      end

      # いったんファイル出力してから戻している時点で相当無駄があるが apng や mp4 の場合でも失敗しない
      def to_write_binary
        Tempfile.open(["", ".#{ext_name}"]) do |t|
          render.write(t.path)
          File.binread(t.path)
        end
      end

      # PNG24 を強制する (for zip)
      def to_png24_binary
        Tempfile.open(["", ".png"]) do |t|
          render.write("PNG24:#{t.path}")
          File.binread(t.path)
        end
      end

      # ImageMagick側で書き出ししているため拡張子に合わせて変換される
      # def write(file)
      #   file = Pathname(file).expand_path.to_s
      #   render.write(file)
      #   file
      # end

      ################################################################################ for debug

      private

      # d Magick::Image.read("logo:").first
      def d(image)
        `open #{o(image)}`
      end

      # o Magick::Image.read("logo:").first
      def o(image, name = nil)
        name ||= SecureRandom.hex
        file = Bundler.root.join("tmp/#{name}.png").expand_path
        FileUtils.makedirs(file.dirname)
        image.write(file)
        puts file
        file
      end
    end
  end
end
