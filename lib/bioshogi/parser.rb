# frozen-string-literal: true

module Bioshogi
  module Parser
    extend self

    # 担当するクラス
    def accepted_class(source)
      support_parsers.find { |e| e.accept?(source) }
    end

    # 棋譜ファイルのコンテンツを読み込む
    def parse(source, options = {})
      source = source_replace(source)
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

    # source が Pathname ならそのファイルから読み込み、文字列なら何もしない
    # こういう設計はやりすぎな感もあるけど open-uri で open が URL にも対応する前例があるのでOK
    def source_normalize(source)
      if source.kind_of?(Pathname)
        source = source.expand_path.read
      end
      s = source.to_s.toutf8.rstrip + "\n"
      s.gsub(/\p{blank}*\R/, "\n") # バイナリだとここで死ぬ
    end

    private

    def source_replace(source)
      # if source
      #   md = source.match(/^[盤面確認]/)
      # end
      source
    end

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
