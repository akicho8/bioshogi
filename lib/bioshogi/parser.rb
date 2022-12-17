# frozen-string-literal: true

module Bioshogi
  module Parser
    extend self

    # 担当するクラス
    def accepted_class(source)
      source = Source.wrap(source)
      support_parsers.find { |e| e.accept?(source) }
    end

    # 棋譜ファイルのコンテンツを読み込む
    def parse(source, options = {})
      source = Source.wrap(source)
      parser = accepted_class(source)
      if !parser
        raise FileFormatError, "棋譜のフォーマットが不明です : #{source}"
      end
      parser.parse(source, options)
    end

    # 棋譜ファイル自体を読み込む
    def file_parse(file, options = {})
      parse(Pathname(file).expand_path.read, options)
    end

    private

    def support_parsers
      [
        SfenParser,
        KifParser,
        CsaParser,
        Ki2Parser,
        BodParser,
      ]
    end
  end
end
