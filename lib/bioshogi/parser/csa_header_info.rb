# frozen-string-literal: true
module Bioshogi
  module Parser
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
    #
    class CsaHeaderInfo
      include ApplicationMemoryRecord
      memory_record [
        # CSA側               KIF/KI2 形式
        {key: "N+",           kif_side_key: "先手",     },
        {key: "N-",           kif_side_key: "後手",     },
        {key: "$EVENT:",      kif_side_key: "棋戦",     },
        {key: "$SITE:",       kif_side_key: "場所",     },
        {key: "$START_TIME:", kif_side_key: "開始日時", },
        {key: "$END_TIME:",   kif_side_key: "終了日時", },
        {key: "$OPENING:",    kif_side_key: "戦型",     },
        {
          key: "$TIME_LIMIT:",
          kif_side_key: "持ち時間",
          as_csa: -> v {
            v = human_or_csa_time_format_to_hash(v)
            "%02d:%02d+%02d" % [*v[:min].to_i.divmod(60), v[:countdown].to_i]
          },
          as_kif: -> v {
            v = human_or_csa_time_format_to_hash(v)

            min = v[:min].to_i
            h, m = min.to_i.divmod(60)
            countdown = v[:countdown].to_i

            s = []
            if h.nonzero?
              s << "#{h}時間"
            end

            if m.nonzero? || countdown.nonzero?
              s << "#{m}分"
            end

            if countdown.nonzero?
              s << " (1手#{countdown}秒)"
            end

            s.join.squish
          },
        },
      ]

      alias csa_key key

      class << self
        def lookup(v)
          super || invert_table[v]
        end

        private

        def invert_table
          @invert_table ||= inject({}) {|a, e| a.merge(e.kif_side_key => e) }
        end
      end

      def human_or_csa_time_format_to_hash(str)
        # チェックする順番重要
        str = str.tr("０-９", "0-9")
        case
        when md = str.match(/(?<hour>\d+):(?<min>\d+)(\+(?<countdown>\d+))?/) # 01:03+00 → {min: 63, countdown: 0}
          {min: md[:hour].to_i * 60 + md[:min].to_i, countdown: md[:countdown].to_i}
        when md = str.match(/((?<hour>\d+)時間)?((?<min>\d+)分)?/)            # 1時間3分 or 1時間 or 3分
          {min: md[:hour].to_i * 60 + md[:min].to_i}
        else
          str
        end
      end
    end
  end
end
