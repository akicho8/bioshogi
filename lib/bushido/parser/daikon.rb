module Bushido
  module Parser
    module Daikon
      extend self

      mattr_accessor(:sep) { "," }

      def split(s)
        s = s.tr("ａ-ｚＡ-Ｚ０-９（）", "a-zA-Z0-9()")
        s = s.gsub(/[＆()・、『』。※「」]+/, sep)
        s = s.gsub(regexp) { |s| "#{sep}#{s}#{sep}" }
        a = s.split(/#{sep}+/)
        a.collect { |e|
          e = e.remove(/\p{blank}/, /\A(\*\d)\z/).presence
        }.compact
      end

      private

      def regexp
        @regexp ||= Regexp.union([
            /(#{kisen_list.join("|")})戦?/,
            /#{keyword.join("|")}/,
            /[一二三四五六七八九十]+[世冠]/,
            /[一二三四五六七八九十]+代目?/,
            /[初二三四五六七八九十]段/,
            /(平成)?\d+年度?/,
            /第\d+[局期]/,
            /第?\d+回戦?/,
            /\d+(歳|年)\b/,
            /\d+級/,
            /小\d+/,
          ])
      end

      def keyword
        @keyword ||= Pathname("#{__dir__}/keyword.txt").read.scan(/\S+/).sort_by { |e| -e.length }
      end

      def kisen_list
        [
          "竜王",
          "名人",
          "棋王",
          "棋聖",
          "王位",
          "王将",
          "王座",
          "叡王",
          "銀河",
          "NHK杯",
          "新人王",
          "倉敷藤花",
          "朝日",
        ]
      end
    end
  end
end
