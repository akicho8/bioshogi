# 戦法チェックで最適化の効果が大きい戦法ランキング

module Bioshogi
  module Analysis
    class NormalizeCheck
      def call
        output_dir = Bioshogi::ROOT.join("tmp/normalize_check")
        output_dir.mkpath
        FileList.new.take(1000).each do |file|
          info = Parser.file_parse(file, typical_error_case: :skip, analysis_feature: true)
          outfile = output_dir.join(file.basename)
          output_kif = info.to_kif
          exist_kif = outfile.existence&.read
          mark = output_kif == exist_kif ? "." : "U"
          puts "#{mark} #{outfile}"
          outfile.write(info.to_kif)
        end
        puts output_dir
      end
    end
  end
end
