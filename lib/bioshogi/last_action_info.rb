# frozen-string-literal: true

module Bioshogi
  # http://www.computer-shogi.org/protocol/record_v22.html
  #
  # (2) 特殊な指し手、終局状況
  # %で始まる。
  # %TORYO 投了
  # %CHUDAN 中断
  # %SENNICHITE 千日手
  # %TIME_UP 手番側が時間切れで負け
  # %ILLEGAL_MOVE 手番側の反則負け、反則の内容はコメントで記録する
  # %+ILLEGAL_ACTION 先手(下手)の反則行為により、後手(上手)の勝ち
  # %-ILLEGAL_ACTION 後手(上手)の反則行為により、先手(下手)の勝ち
  # %JISHOGI 持将棋
  # %KACHI (入玉で)勝ちの宣言
  # %HIKIWAKE (入玉で)引き分けの宣言
  # %MATTA 待った
  # %TSUMI 詰み
  # %FUZUMI 不詰
  # %ERROR エラー
  # ※文字列は、空白を含まない。
  # ※%KACHI,%HIKIWAKE は、コンピュータ将棋選手権のルールに対応し、
  # 第3版で追加。
  # ※%+ILLEGAL_ACTION,%-ILLEGAL_ACTIONは、手番側の勝ちを表現できる。

  # 激指は次のどれか以外にすると読み込めなくなるので注意
  # 中断, 投了, 持将棋, 千日手, 詰み, 切れ負け

  class LastActionInfo
    include ApplicationMemoryRecord
    memory_record [
      # 手番による勝者判定が可能なら win_player_collect_p を true にする
      # CHUDAN などはどちらが中断(切断)したのかもしわからない
      { key: "TORYO",           kakinoki_word: "投了",       reason: nil,              draw: nil,  win_player_collect_p: true, },
      { key: "CHUDAN",          kakinoki_word: "中断",       reason: "切断により",     draw: nil,  win_player_collect_p: nil,  }, # 切断の場合どちらが切断したのかわからないため win_player_collect_p: true にしてはいけない
      { key: "SENNICHITE",      kakinoki_word: "千日手",     reason: "千日手",         draw: true, win_player_collect_p: nil,  },
      { key: "TIME_UP",         kakinoki_word: "切れ負け",   reason: "時間切れにより", draw: nil,  win_player_collect_p: true, },
      { key: "ILLEGAL_MOVE",    kakinoki_word: nil,          reason: "反則により",     draw: nil,  win_player_collect_p: nil,  },
      { key: "+ILLEGAL_ACTION", kakinoki_word: nil,          reason: "反則により",     draw: nil,  win_player_collect_p: nil,  },
      { key: "-ILLEGAL_ACTION", kakinoki_word: nil,          reason: "反則により",     draw: nil,  win_player_collect_p: nil,  },
      { key: "JISHOGI",         kakinoki_word: "持将棋",     reason: nil,              draw: nil,  win_player_collect_p: nil,  },
      { key: "KACHI",           kakinoki_word: nil,          reason: nil,              draw: nil,  win_player_collect_p: nil,  }, # この場合、win_player が信用できなくなり、つまりどちらが勝ったのかわからなくなる
      { key: "HIKIWAKE",        kakinoki_word: nil,          reason: nil,              draw: nil,  win_player_collect_p: nil,  },
      { key: "MATTA",           kakinoki_word: "中断",       reason: nil,              draw: nil,  win_player_collect_p: nil,  },
      { key: "TSUMI",           kakinoki_word: "詰み",       reason: nil,              draw: nil,  win_player_collect_p: true, },
      { key: "FUZUMI",          kakinoki_word: nil,          reason: nil,              draw: nil,  win_player_collect_p: nil,  },
      { key: "ERROR",           kakinoki_word: nil,          reason: "エラーにより",   draw: nil,  win_player_collect_p: nil,  },
    ]

    alias csa_key key

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= find_all(&:kakinoki_word).inject({}) { |a, e| a.merge(e.kakinoki_word => e) }
      end
    end

    def judgment_message(container)
      if win_player_collect_p
        s = []
        s << "まで#{container.turn_info.turn_offset}手で"
        s << reason
        unless draw
          s << container.opponent_player.call_name # これが信じられるのは win_player_collect_p のときだけ
          s << "の"
          s << "勝ち"
        end
        s.join
      end
    end

    def last_checkmate_p
      key == :TSUMI
    end

    def container_params
      {
        win_player_collect_p:, # 勝ち負けがついた一般的な終わり方をしたか？
        last_checkmate_p:,     # 詰みまで指したか？
      }
    end
  end
end
