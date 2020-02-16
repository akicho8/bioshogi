module Bioshogi
  module Formatter
    concern :CsaFormatter do
      # CSA標準棋譜ファイル形式
      # http://www.computer-shogi.org/protocol/record_v22.html ← 見れなくなった
      # http://www2.computer-shogi.org/protocol/tcp_ip_server_121.html
      #
      #   V2.2
      #   N+久保利明 王将
      #   N-都成竜馬 四段
      #   $EVENT:王位戦
      #   $SITE:関西将棋会館
      #   $START_TIME:2017/11/16 10:00:00
      #   $END_TIME:2017/11/16 19:04:00
      #   $OPENING:相振飛車
      #   P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
      #   P2 * -HI *  *  *  *  * -KA *
      #   P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
      #   P4 *  *  *  *  *  *  *  *  *
      #   P5 *  *  *  *  *  *  *  *  *
      #   P6 *  *  *  *  *  *  *  *  *
      #   P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
      #   P8 * +KA *  *  *  *  * +HI *
      #   P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
      #   +
      #   +7776FU
      #   -3334FU
      #   %TORYO
      #
      def to_csa(**options)
        options = {
          board_expansion: false, # 平手であっても P1 形式で表示
          compact: false,         # 指し手の部分だけ一行にする
          oneline: false,         # 一行にする。改行もなし
          header_skip: false,
        }.merge(options)

        mediator_run

        out = []
        out << "V2.2\n"

        unless options[:header_skip]
          out << CsaHeaderInfo.collect { |e|
            if v = header[e.kif_side_key].presence
              if e.as_csa
                v = e.instance_exec(v, &e.as_csa)
              end
              "#{e.csa_key}#{v}\n"
            end
          }.join
        end

        obj = Mediator.new
        board_setup(obj)
        out << obj.to_csa(options)

        if options[:compact]
          sep = ","
        else
          sep = "\n"
        end

        # 2通りある
        # 1. 初期盤面の状態から調べた手合割を利用して最初の手番を得る  (turn_info = TurnInfo.new(preset_key))
        # 2. mediator.turn_info を利用して mediator.turn_info.base_location.csa_sign を参照
        # ↑どちらも違う
        # 3. これが正しい
        out << mediator.turn_info.turn_offset_zero_location.csa_sign + "\n"

        list = mediator.hand_logs.collect.with_index do |e, i|
          if clock_exist?
            [e.to_csa, "T#{used_seconds_at(i)}"].join(",")
          else
            e.to_csa
          end
        end

        out << list.join(sep) + "\n"

        if e = @last_status_params
          # 将棋倶楽部24の棋譜は先手の手番で後手が投了できる「反則勝ち」が last_action_key 入っているたため、LastActionInfo を fetch できない
          # なので仕方なく TORYO にしている。これは実際には後手が投了したのに先手が投了したことになってしまう表記なのでおかしい
          # これは将棋倶楽部24に仕様を正してもらうか、CSA 側でそれに対応するキーワードを用意してもらうしかない
          last_action_info = LastActionInfo.lookup(e[:last_action_key]) || LastActionInfo[:TORYO]
          s = "%#{last_action_info.csa_key}"
          if v = e[:used_seconds]
            s += ",T#{v}"
          end
          out << s
        else
          out << "%TORYO"
        end

        if @error_message
          out << error_message_part(Parser::CsaParser.comment_char)
        end

        out = out.join

        if options[:oneline]
          out = out.gsub(/\n/, ",")
        else
          out += "\n"

          if ENV["BIOSHOGI_ENV"] == "test"
            out = out.gsub(/\s+\n/, "\n")
          end
        end

        out
      end
    end
  end
end
