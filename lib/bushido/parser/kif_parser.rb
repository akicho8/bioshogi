# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module Parser
    class KifParser < Base
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
          source.match?(/^手数-+指手-+消費時間-+$/)
        end
      end

      # | # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # | key：value
      # | 手数----指手---------消費時間--
      # | *コメント0
      # |    1 ７六歩(77)   ( 0:00/00:00:00)
      #
      #   @result.move_infos.first.should == {turn_number: "1", input: "７六歩(77)", spent_time: "0:10/00:00:10", comments: ["コメント1"]}
      #   @result.move_infos.last.should  == {turn_number: "5", input: "投了", spent_time: "0:10/00:00:50"}
      #
      def parse
        @_head, @_body = normalized_source.split(/^手数.*指手.*消費時間.*$/, 2)
        header_read
        board_read
        @_body.lines.each do |line|
          comment_read(line)
          if md = line.match(/^\s*(?<turn_number>\d+)\s+(?<input>\S+)(\s+\(\s*(?<spent_time>.*)\))?/)
            location = Location["#{md[:turn_number]}手目"]
            input = md[:input].remove(/\p{blank}/)
            @move_infos << {turn_number: md[:turn_number], location: location, input: input, mov: "#{location.mark}#{input}", spent_time: md[:spent_time]}
          end
        end
      end

      # これは簡易版
      def to_direct_kif
        out = ""
        out << @header.collect { |key, value| "#{key}：#{value}\n" }.join
        out << "手数----指手---------消費時間--\n"
        @move_infos.each do |e|
          out << "%s %s (%s)\n" % [e[:turn_number], e[:input], e[:spent_time]]
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
    end
  end
end
