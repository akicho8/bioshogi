# frozen-string-literal: true

module Bioshogi
  module Formatter
    module Animation
      class SerialFilenameGenerator
        attr_accessor :index
        attr_accessor :prefix
        attr_accessor :ext_type
        attr_accessor :number_format

        def initialize(prefix: "_input", index: 0, ext_type: "png", number_format: "%04d")
          @prefix = prefix
          @index = index
          @ext_type = ext_type
          @number_format = number_format
        end

        def next
          format("PNG24:#{name}", @index).tap { @index += 1 }
        end

        def name
          "#{@prefix}#{@number_format}.#{ext_type}"
        end

        def exist_files
          Dir[wild_name]
        end

        def shell_inspect
          `ls -alh #{wild_name}`
        end

        def info
          {
            "ページ数"       => index,
            "存在ファイル数" => exist_files.count,
            "ファイル名"     => name,
          }
        end

        def inspect
          info.collect { |k, v| "#{k}: #{v}" }.join(", ")
        end

        private

        def wild_name
          "#{prefix}*.#{ext_type}"
        end
      end
    end
  end
end
