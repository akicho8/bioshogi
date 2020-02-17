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
      { key: "TORYO",           kif_word: "投了",       reason: nil,              draw: nil,  },
      { key: "CHUDAN",          kif_word: "中断",       reason: "切断により",     draw: nil,  },
      { key: "SENNICHITE",      kif_word: "千日手",     reason: "千日手",         draw: true, },
      { key: "TIME_UP",         kif_word: "切れ負け",   reason: "時間切れにより", draw: nil,  },
      { key: "ILLEGAL_MOVE",    kif_word: nil,          reason: "反則により",     draw: nil,  },
      { key: "+ILLEGAL_ACTION", kif_word: nil,          reason: "反則により",     draw: nil,  },
      { key: "-ILLEGAL_ACTION", kif_word: nil,          reason: "反則により",     draw: nil,  },
      { key: "JISHOGI",         kif_word: "持将棋",     reason: nil,              draw: nil,  },
      { key: "KACHI",           kif_word: nil,          reason: nil,              draw: nil,  },
      { key: "HIKIWAKE",        kif_word: nil,          reason: nil,              draw: nil,  },
      { key: "MATTA",           kif_word: "中断",       reason: nil,              draw: nil,  },
      { key: "TSUMI",           kif_word: "詰み",       reason: nil,              draw: nil,  },
      { key: "FUZUMI",          kif_word: nil,          reason: nil,              draw: nil,  },
      { key: "ERROR",           kif_word: nil,          reason: "エラーにより",   draw: nil,  },
    ]

    alias csa_key key

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= find_all(&:kif_word).inject({}) {|a, e| a.merge(e.kif_word => e) }
      end
    end

    def judgment_message(mediator)
      if Bioshogi.if_starting_from_the_2_hand_second_is_also_described_from_2_hand_first_kif
        n = mediator.turn_info.display_turn
      else
        n = mediator.turn_info.turn_offset
      end

      s = []
      s << "まで#{n}手で"
      s << reason
      unless draw
        s << mediator.opponent_player.call_name
        s << "の"
        s << "勝ち"
      end
      s.join
    end
  end
end
