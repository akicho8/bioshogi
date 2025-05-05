# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :StaticKifMod do
      # この戦法を発動する代表とする棋譜ファイル
      def static_kif_file
        @static_kif_file ||= Pathname("#{__dir__}/#{tactic_info.name}/#{key}.kif")
      end

      # この戦法を発動する代表とする棋譜ファイルの情報
      def static_kif_info(options = {})
        Parser.file_parse(static_kif_file, options)
      end

      # この戦法を発動するファイルたち
      def reference_files
        @reference_files ||= [
          static_kif_file,
          *Pathname("#{__dir__}/#{tactic_info.name}").glob("#{key}/**/*.kif"),
        ]
      end
    end
  end
end
