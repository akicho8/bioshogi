# frozen-string-literal: true
# bioshogi convert -f ki2 ../../../experiment/katomomo.kif

if $0 == __FILE__
  require "../cli"
end

module Bioshogi
  class Cli
    desc "convert", "一括棋譜フォーマット変換"
    option :format,     type: :string, aliases: "-f", default: "kif"
    option :output_dir, type: :string, aliases: "-o", default: "output"
    def convert(*files)
      files.each do |in_file|
        in_file = Pathname(in_file).expand_path
        info = Parser.file_parse(in_file)
        str = info.public_send("to_#{options[:format]}")
        if options[:output_dir].blank?
          puts str
        else
          dir = Pathname(options[:output_dir]).expand_path
          out_file = dir.join("#{in_file.basename(".*")}.#{options[:format]}")
          FileUtils.mkdir_p(dir)
          out_file.write(str)
          puts "#{in_file} => #{out_file}"
        end
      end
    end
  end
end

if $0 == __FILE__
  Bioshogi::Cli.start(["convert", "-f", "ki2", "../../../experiment/katomomo.kif"])
end
