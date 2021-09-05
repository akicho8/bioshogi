require "tempfile"
require "securerandom"

module Bioshogi
  class ImageRenderer
    concerning :Helper do
      # 最後の build の結果を保持するバージョン
      # mp4_builder, animation_gif_builder だけで使っている
      begin
        attr_reader :last_build

        def next_build
          @last_build = build
        end
      end

      # png や gif は問題ないが apng や mp4 の場合に失敗する → ImageList#format に設定しているせいっぽい
      # そもそも画像リストを write("foo.png") にすると foo-0.png foo-1.png などと複数生成されるのだから
      # write は拡張子に合わせて format を設定して to_blob の結果を write しているのではないことがわかる
      def to_blob_binary
        image = build
        image.format = ext_name
        image.to_blob
      end

      # いったんファイル出力してから戻している時点で相当無駄があるが apng や mp4 の場合でも失敗しない
      def to_write_binary
        Tempfile.open(["", ".#{ext_name}"]) do |t|
          build.write(t.path)
          File.binread(t.path)
        end
      end

      # ImageMagick側で書き出ししているため拡張子に合わせて変換される
      # def write(file)
      #   file = Pathname(file).expand_path.to_s
      #   build.write(file)
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
