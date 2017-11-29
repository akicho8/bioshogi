# frozen-string-literal: true

module Bushido
  module Parser
    class LastActionInfo
      include MemoryRecord
      memory_record [
        {key: "TORYO",           kif_diarect: "投了",                                             },
        {key: "CHUDAN",          kif_diarect: "中断",                                             },
        {key: "SENNICHITE",      kif_diarect: "千日手",                                           },
        {key: "TIME_UP",         kif_diarect: "手番側が時間切れで負け",                           },
        {key: "ILLEGAL_MOVE",    kif_diarect: "手番側の反則負け、反則の内容はコメントで記録する", },
        {key: "+ILLEGAL_ACTION", kif_diarect: "先手(下手)の反則行為により、後手(上手)の勝ち",     },
        {key: "-ILLEGAL_ACTION", kif_diarect: "後手(上手)の反則行為により、先手(下手)の勝ち",     },
        {key: "JISHOGI",         kif_diarect: "持将棋",                                           },
        {key: "KACHI",           kif_diarect: "(入玉で)勝ちの宣言",                               },
        {key: "HIKIWAKE",        kif_diarect: "(入玉で)引き分けの宣言",                           },
        {key: "MATTA",           kif_diarect: "待った",                                           },
        {key: "TSUMI",           kif_diarect: "詰み",                                             },
        {key: "FUZUMI",          kif_diarect: "不詰",                                             },
        {key: "ERROR",           kif_diarect: "エラー",                                           },
      ]

      alias csa_key key

      class << self
        def lookup(v)
          super || invert_table[v]
        end

        private

        def invert_table
          @invert_table ||= inject({}) {|a, e| a.merge(e.kif_diarect => e) }
        end
      end
    end
  end
end
