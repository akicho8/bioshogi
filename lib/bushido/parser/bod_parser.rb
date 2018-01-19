# frozen-string-literal: true

module Bushido
  module Parser
    class BodParser < Base
      cattr_accessor(:henka_reject) { true }
      cattr_accessor(:kif_separator) { /手数-+指手-+消費時間-+/ }

      class << self
        # > 後手：羽生善治
        # > 後手の持駒：飛　角　金　銀　桂　香　歩四　
        # >   ９ ８ ７ ６ ５ ４ ３ ２ １
        # > +---------------------------+
        # > |v香v桂 ・ ・ ・ ・ ・ ・ ・|一
        # > | ・ ・ ・ 馬 ・ ・ 龍 ・ ・|二
        # > | ・ ・v玉 ・v歩 ・ ・ ・ ・|三
        # > |v歩 ・ ・ ・v金 ・ ・ ・ ・|四
        # > | ・ ・v銀 ・ ・ ・v歩 ・ ・|五
        # > | ・ ・ ・ ・ 玉 ・ ・ ・ ・|六
        # > | 歩 歩 ・ 歩 歩v歩 歩 ・ 歩|七
        # > | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
        # > | 香 桂v金 ・v金 ・ ・ 桂 香|九
        # > +---------------------------+
        # > 先手：谷川浩司
        # > 先手の持駒：銀二　歩四　
        # > 手数＝171  ▲６二角成  まで
        # > *第44期王位戦第4局
        # >
        # > 後手番
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(/^手数.*まで$/)
        end
      end

      def parse
        header_read
        header_normalize
        board_read

        normalized_source.lines.each do |line|

          # 激指で作った分岐対応KIFを読んだ場合「変化：8手」のような文字列が来た時点で打ち切る
          if henka_reject
            if line.match?(/^\p{blank}*変化：/)
              break
            end
          end

          comment_read(line)
          if md = line.match(/^\p{blank}*(?<turn_number>\d+)\p{blank}*(?<input>#{Runner.input_regexp})(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/o)
            input = md[:input].remove(/\p{blank}/)
            used_seconds = min_sec_str_to_seconds(md[:clock_part])
            @move_infos << {turn_number: md[:turn_number], input: input, clock_part: md[:clock_part], used_seconds: used_seconds}
          else
            if md = line.match(/^\p{blank}*(?<turn_number>\d+)\p{blank}*(?<last_action_key>\S+)(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/)
              used_seconds = min_sec_str_to_seconds(md[:clock_part])
              @last_status_params = {last_action_key: md[:last_action_key], used_seconds: used_seconds}
            end
          end
        end
      end

      def min_sec_str_to_seconds(s)
        if s.present?
          if v = s.match(/(?<m>\d+):(?<s>\d+)/)
            v[:m].to_i.minutes + v[:s].to_i.seconds
          end
        end
      end

      # これは簡易版
      def to_direct_kif
        out = ""
        out << @header.collect { |key, value| "#{key}：#{value}\n" }.join
        out << "手数----指手---------消費時間--\n"
        @move_infos.each do |e|
          out << "%s %s (%s)\n" % [e[:turn_number], e[:input], e[:clock_part]]
        end

        # 最後が「投了」でない場合に kif フォーマットと見なされない場合がある(将棋山脈など)
        # そのため最後が投了でない場合、自動的に投了を入れている
        if true
          last = @move_infos.last
          unless last[:input] == "投了"
            out << "%s 投了\n" % last[:turn_number].next
          end
        end

        out
      end

      # alias to_s to_direct_kif

      private

      def header_normalize
        super

        # もしあれば削除
        if henka_reject
          header.object.delete("変化")
        end
      end
    end
  end
end
