module Bushido
  module Parser
    concern :CsaSerializer do
      # CSA標準棋譜ファイル形式
      # http://www.computer-shogi.org/protocol/record_v22.html
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
          board_expansion: false,
          strip: false, # テストですぐに差分が出てしまって転けるので右側のスペースを取る
        }.merge(options)

        mediator_run

        out = []
        out << "V2.2\n"

        out << CsaHeaderInfo.collect { |e|
          if v = header[e.kif_side_key].presence
            if e.as_csa
              v = e.instance_exec(v, &e.as_csa)
            end
            "#{e.csa_key}#{v}\n"
          end
        }.join

        preset_name = nil
        if true
          obj = Mediator.new
          obj.board_reset_old(@board_source || header["手合割"])
          preset_name = obj.board.preset_name
          if preset_name
            out << "#{Parser::CsaParser.comment_char} 手合割:#{preset_name}\n"
          end
          if options[:board_expansion]
            out << obj.board.to_csa
          else
            if preset_name == "平手"
              out << "PI\n"
            else
              out << obj.board.to_csa
            end
          end
        end

        # 2通りある
        # 1. 初期盤面の状態から調べた手合割を利用して最初の手番を得る  (turn_info = TurnInfo.new(preset_name))
        # 2. mediator.turn_info を利用する
        out << mediator.turn_info.base_location.csa_sign + "\n"

        out << mediator.hand_logs.collect.with_index { |e, i|
          if clock_exist?
            "#{e.to_s_csa},T#{used_seconds_at(i)}\n"
          else
            e.to_s_csa + "\n"
          end
        }.join

        if e = @last_status_params
          last_action_info = LastActionInfo.fetch(e[:last_action_key])
          s = "%#{last_action_info.csa_key}"
          if v = e[:used_seconds]
            s += ",T#{v}"
          end
          out << "#{s}\n"
        else
          out << "%TORYO" + "\n"
        end

        if @error_message
          out << error_message_part(Parser::CsaParser.comment_char)
        end

        out = out.join

        # テスト用
        if options[:strip]
          out = out.gsub(/\s+\n/, "\n")
        end

        out
      end
    end
  end
end
