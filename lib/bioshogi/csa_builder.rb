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

    CSA_VERSION = "2.2"

    class << self
      def default_params
        super.merge({
            :board_expansion => false, # 平手であっても P1 形式で表示
            :compact         => false, # 指し手の部分だけ一行にする
            :oneline         => false, # 一行にする。改行もなし
            :has_header      => true,
            :has_footer      => true,
          })
      end
    end

    def initialize(exporter, params = {})
      @exporter = exporter
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @exporter.xcontainer_run_once

      out = []
      out << "V#{CSA_VERSION}\n"

      if @params[:has_header]
        out << header_content
      end

      obj = Xcontainer.new
      @exporter.xcontainer_init(obj) # なぜ？
      out << obj.to_csa(@params)

      out << body_hands

      if @params[:has_footer]
        out << footer_content
      end

      if @exporter.mi.error_message
        out << @exporter.error_message_part(Parser::CsaParser::SYSTEM_COMMENT_CHAR)
      end

      out = out.join

      if @params[:oneline]
        out = out.gsub(/\n/, ",")
      else
        out += "\n"
        out = out.gsub(/\s+\n/, "\n")
      end

      out
    end

    private

    def header_content
      CsaHeaderInfo.collect { |e|
        if v = @exporter.mi.header[e.kif_side_key].presence
          if e.as_csa
            v = e.instance_exec(v, &e.as_csa)
          end
          "#{e.csa_key}#{v}\n"
        end
      }.join
    end

    def body_hands
      out = []

      # 2通りある
      # 1. 初期盤面の状態から調べた手合割を利用して最初の手番を得る  (turn_info = TurnInfo.new(preset_key))
      # 2. xcontainer.turn_info を利用して xcontainer.turn_info.base_location.csa_sign を参照
      # ↑どちらも違う
      # 3. これが正しい
      out << @exporter.xcontainer.turn_info.turn_offset_zero_location.csa_sign + "\n"

      if @exporter.xcontainer.hand_logs.present?
        list = @exporter.xcontainer.hand_logs.collect.with_index do |e, i|
          if @exporter.clock_exist?
            [e.to_csa, "T#{@exporter.used_seconds_at(i)}"].join(",")
          else
            e.to_csa
          end
        end
        out << list.join(separator) + "\n"
      end

      out.join
    end

    # 将棋倶楽部24の棋譜は先手の手番で後手が投了できる「反則勝ち」が last_action_key 入っているたため、LastActionInfo を fetch できない
    # なので仕方なく TORYO にしている。これは実際には後手が投了したのに先手が投了したことになってしまう表記なのでおかしい
    # これは将棋倶楽部24に仕様を正してもらうか、CSA 側でそれに対応するキーワードを用意してもらうしかない
    def footer_content
      av = []
      hv = @exporter.mi.last_action_params || { last_action_key: "TORYO" }
      last_action_info = LastActionInfo[hv[:last_action_key]] || LastActionInfo[:TORYO]
      av << "%#{last_action_info.csa_key}"
      if v = hv[:used_seconds]
        av << "T#{v}"
      end
      av.join(",") + "\n"
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
