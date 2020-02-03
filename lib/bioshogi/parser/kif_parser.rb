# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  module Parser
    class KifParser < Base
      cattr_accessor(:henka_reject) { true }
      cattr_accessor(:kif_separator) { /手数-+指手-+消費時間/ }
      cattr_accessor(:line_regexp) { /^\p{blank}*(?<turn_number>\d+)\p{blank}*(?<input>#{InputParser.regexp})(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/o }
      cattr_accessor(:line_regexp2) { /^\p{blank}*(?<turn_number>\d+)\p{blank}*(?<last_action_key>\S+)(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/ }

      class << self
        # KIFフォーマットかどうかの判定
        # @example 将棋ウォーズ棋譜検索β http://swks.sakura.ne.jp/wars/kifusearch/ での棋譜フォーマット
        #   開始日時：2013/06/09 20:13:46
        #   棋戦：将棋ウォーズ(弾丸)
        #   持ち時間：3分切れ負け
        #   手合割：平手
        #   先手：akicho8
        #   後手：JackTuti
        #   手数----指手---------消費時間--
        #   1 ７六歩(77)   ( 00:01/00:00:01)
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(kif_separator) || source.match?(line_regexp) || source.match?(line_regexp2)
        end
      end

      # | # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # | key：value
      # | 手数----指手---------消費時間--
      # | *コメント0
      # |    1 ７六歩(77)   ( 0:00/00:00:00)
      # |    2 投了         ( 0:00/00:00:00)
      # | 変化：1手
      # |    1 ２六歩(25)   ( 0:00/00:00:00)
      #
      # assert { @result.move_infos.first == {turn_number: "1", input: "７六歩(77)", clock_part: "0:10/00:00:10", comments: ["コメント1"]} }
      # assert { @result.move_infos.last  == {turn_number: "5", input: "投了", clock_part: "0:10/00:00:50"} }
      #
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
          if md = line.match(line_regexp)
            input = md[:input].remove(/\p{blank}/)
            used_seconds = min_sec_str_to_seconds(md[:clock_part])
            @move_infos << {turn_number: md[:turn_number], input: input, clock_part: md[:clock_part], used_seconds: used_seconds}
          else
            if md = line.match(line_regexp2)
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
