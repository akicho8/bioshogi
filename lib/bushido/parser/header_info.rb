module Bushido
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
    class HeaderInfo
      include MemoryRecord
      memory_record [
        {csa_key: "N+",           kif_key: "先手",     },
        {csa_key: "N-",           kif_key: "後手",     },
        {csa_key: "$EVENT:",      kif_key: "棋戦",     },
        {csa_key: "$SITE:",       kif_key: "場所",     },
        {csa_key: "$START_TIME:", kif_key: "開始日時", },
        {csa_key: "$END_TIME:",   kif_key: "終了日時", },
        {csa_key: "$OPENING:",    kif_key: "戦型",     },
      ]
    end
  end
end
