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

    ################################################################################ for debug

    def display
      system "open #{to_tempfile}"
    end

    # ImageMagick側で書き出ししているため拡張子に合わせて変換される
    def write(file)
      file = Pathname(file).expand_path.to_s
      main_canvas.write(file)
      file
    end

    def to_tempfile
      require "tmpdir"
      require "securerandom"
      write("#{Dir.tmpdir}/#{Time.now.strftime('%Y%m%m%H%M%S')}_#{SecureRandom.hex}.#{ext_name}")
    end
  end
end
