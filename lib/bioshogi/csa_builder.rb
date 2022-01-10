# frozen-string-literal: true
#
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
#
module Bioshogi
  class CsaBuilder
    include Builder

    def self.default_params
      super.merge({
          :board_expansion => false, # 平手であっても P1 形式で表示
          :compact         => false, # 指し手の部分だけ一行にする
          :oneline         => false, # 一行にする。改行もなし
          :header_skip     => false,
          :footer_skip     => false,
        })
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @parser.mediator_run_once

      out = []
      out << "V2.2\n"

      unless @params[:header_skip]
        out << CsaHeaderInfo.collect { |e|
          if v = @parser.header[e.kif_side_key].presence
            if e.as_csa
              v = e.instance_exec(v, &e.as_csa)
            end
            "#{e.csa_key}#{v}\n"
          end
        }.join
      end

      obj = Mediator.new
      @parser.mediator_board_setup(obj) # なぜ？
      out << obj.to_csa(@params)

      out << body_hands

      unless @params[:footer_skip]
        if e = @parser.last_action_params
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
      end

      if @parser.error_message
        out << @parser.error_message_part(Parser::CsaParser.comment_char)
      end

      out = out.join

      if @params[:oneline]
        out = out.gsub(/\n/, ",")
      else
        out += "\n"

        if ENV["BIOSHOGI_ENV"] == "test"
          out = out.gsub(/\s+\n/, "\n")
        end
      end

      out
    end

    private

    def body_hands
      out = []

      # 2通りある
      # 1. 初期盤面の状態から調べた手合割を利用して最初の手番を得る  (turn_info = TurnInfo.new(preset_key))
      # 2. mediator.turn_info を利用して mediator.turn_info.base_location.csa_sign を参照
      # ↑どちらも違う
      # 3. これが正しい
      out << @parser.mediator.turn_info.turn_offset_zero_location.csa_sign + "\n"

      if @parser.mediator.hand_logs.present?
        list = @parser.mediator.hand_logs.collect.with_index do |e, i|
          if @parser.clock_exist?
            [e.to_csa, "T#{@parser.used_seconds_at(i)}"].join(",")
          else
            e.to_csa
          end
        end
        out << list.join(separator) + "\n"
      end

      out.join
    end

    def separator
      if @params[:compact]
        ","
      else
        "\n"
      end
    end
  end
end
