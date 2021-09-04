require "tempfile"
require "tmpdir"
require "securerandom"

module Bioshogi
  class BinaryFormatter
    class << self
      def assert_valid_keys(params)
        params.assert_valid_keys(all_options.keys)
      end

      def all_options
        [AnimationFormatter, ImageFormatter].inject({}) {|a, e| a.merge(e.default_params) }
      end

      def render(*args)
        new(*args).tap(&:render)
      end
    end

    # png や gif は問題ないが apng や mp4 の場合に失敗する(悲)
    # そもそも画像リストを write("foo.png") にすると foo-0.png foo-1.png などと複数生成されるのだから
    # write は拡張子に合わせて format を設定して to_blob の結果を write しているのではないことがわかる
    def to_blob_binary
      rendered_image.format = ext_name
      rendered_image.to_blob
    end

    # いったんファイル出力してから戻している時点で相当無駄があるが
    # apng や mp4 の場合でも失敗しない
    def to_write_binary
      Tempfile.open(["", ".#{ext_name}"]) do |t|
        rendered_image.write(t.path)
        File.binread(t.path)
      end
    end

    ################################################################################ for debug

    def display
      system "open #{to_tempfile}"
    end

    # ImageMagick側で書き出ししているため拡張子に合わせて変換される
    def write(file)
      file = Pathname(file).expand_path.to_s
      rendered_image.write(file)
      file
    end

    def to_tempfile
      write("#{Dir.tmpdir}/#{Time.now.strftime('%Y%m%m%H%M%S')}_#{SecureRandom.hex}.#{ext_name}")
    end
  end
end
