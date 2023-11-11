# -*- compile-command: "../../../.bin/bioshogi convert -f sfen ../assets/kifu_formats/sample.kif" -*-

module Bioshogi
  module Commands
    class Convert
      def initialize(files, options = {})
        @files = files
        @options = {
          :format     => "kif",
          :output_dir => nil,
          :overwrite  => false,
        }.merge(options)
      end

      def call
        @files.each { |e| process_one(e) }
      end

      def process_one(in_file)
        in_file = Pathname(in_file).expand_path
        info = Parser.file_parse(in_file)
        str = info.public_send("to_#{@options[:format]}")
        case
        when @options[:overwrite]
          in_file.write(str)
          puts "[overwrite] #{in_file} => #{out_file}"
        when @options[:output_dir].present?
          out_file = output_dir + in_file.basename.sub_ext(extname)
          FileUtils.mkdir_p(out_file.dirname)
          out_file.write(str)
          puts "[output] #{in_file} => #{out_file}"
        else
          puts str
        end
      end

      def output_dir
        Pathname(@options[:output_dir]).expand_path
      end

      def extname
        ".#{@options[:format]}"
      end
    end
  end
end
