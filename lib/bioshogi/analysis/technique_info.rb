# frozen-string-literal: true

module Bioshogi
  module Analysis
    class TechniqueInfo
      include ApplicationMemoryRecord
      memory_record attr_reader: TagColumnNames do
        [
          # 歩
          { key: "垂れ歩",       alias_names: nil, outbreak_skip: nil,  },
          { key: "たたきの歩",   alias_names: nil, outbreak_skip: nil,  },
          { key: "継ぎ歩",       alias_names: nil, outbreak_skip: nil,  },
          { key: "連打の歩",     alias_names: nil, outbreak_skip: nil,  },
          { key: "蓋歩",         alias_names: nil, outbreak_skip: nil,  },
          { key: "歩裏の歩",     alias_names: nil, outbreak_skip: nil,  },
          { key: "突き違いの歩", alias_names: nil, outbreak_skip: true, },
          { key: "こびん攻め",   alias_names: nil, outbreak_skip: nil,  },
          { key: "端攻め",       alias_names: nil, outbreak_skip: nil,  },
          { key: "端玉には端歩", alias_names: nil, outbreak_skip: nil,  },
          { key: "歩切れ",       alias_names: nil, outbreak_skip: nil,  },
          { key: "歩偏執者",},

          # 歩 (マイナス)
          { key: "居飛車の税金", alias_names: nil, outbreak_skip: true, },
          { key: "金底の歩",     alias_names: nil, outbreak_skip: nil,  },
          { key: "土下座の歩",   alias_names: nil, outbreak_skip: nil,  },

          # と
          { key: "勝ち確5三と",  alias_names: "5三のと金に負けなし", },
          { key: "と金攻め",     alias_names: nil,                   },
          { key: "マムシのと金", alias_names: nil,                   },

          # 香
          { key: "田楽刺し",    },
          { key: "下段の香",    },
          { key: "歩裏の香",    },
          # 香 + 飛 (特別判定)
          { key: "ロケット",    group_key: "ロケット", },
          { key: "2段ロケット", group_key: "ロケット", },
          { key: "3段ロケット", group_key: "ロケット", },
          { key: "4段ロケット", group_key: "ロケット", },
          { key: "5段ロケット", group_key: "ロケット", },
          { key: "6段ロケット", group_key: "ロケット", },

          # 桂
          { key: "ふんどしの桂", outbreak_skip: nil,  },
          { key: "控えの桂",     outbreak_skip: nil,  },
          { key: "継ぎ桂",       outbreak_skip: nil,  },
          { key: "跳ね違いの桂", outbreak_skip: nil,  },
          { key: "パンツを脱ぐ", outbreak_skip: true, },
          { key: "歩頭の桂",     outbreak_skip: nil,  },
          { key: "金頭の桂",     outbreak_skip: nil,  },

          # 銀
          { key: "割り打ちの銀", outbreak_skip: nil,  },
          { key: "たすきの銀",   outbreak_skip: nil,  },
          { key: "位の確保",     outbreak_skip: true, },
          { key: "銀ばさみ",     outbreak_skip: true, },
          { key: "桂頭の銀",     outbreak_skip: nil,  },
          { key: "銀不成",       outbreak_skip: nil,  },

          { key: "壁銀", },
          { key: "頭銀", },
          { key: "腹銀", },
          { key: "尻銀", },
          { key: "肩銀", },
          { key: "裾銀", },

          # 金
          { key: "壁金", },
          { key: "頭金", },
          { key: "腹金", },
          { key: "尻金", },
          { key: "肩金", },
          { key: "裾金", },

          # 角
          { key: "幽霊角",       alias_names: "端角", },
          { key: "遠見の角",     alias_names: nil,    },
          { key: "たすきの角",   alias_names: nil,    },
          { key: "自陣角",       alias_names: nil,    },
          { key: "守りの馬",     alias_names: nil,    },

          # 飛
          { key: "飛車先交換",   alias_names: nil, outbreak_skip: nil,  },
          { key: "浮き飛車",     alias_names: nil, outbreak_skip: true, },
          { key: "自陣飛車",     alias_names: nil, outbreak_skip: nil,  },
          { key: "二枚飛車",     alias_names: nil, outbreak_skip: nil,  },
          { key: "一間竜",       alias_names: nil, outbreak_skip: nil,  },

          # 玉
          { key: "端玉",         alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "ハッチ閉鎖",   alias_names: nil, outbreak_skip: true, add_to_opponent: nil,        },
          { key: "玉飛接近",     alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "銀冠の小部屋", alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "裸玉",         alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "桂頭の玉",     alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "中段玉",       alias_names: nil, outbreak_skip: nil,  add_to_opponent: nil,        },
          { key: "双玉接近",     alias_names: nil, outbreak_skip: nil,  add_to_opponent: "双玉接近", },

          # 対局時の状況
          { key: "駒柱",             add_to_opponent: "駒柱",         },

          { key: "大駒コンプリート", add_to_opponent: "大駒全ブッチ", },
          { key: "大駒全ブッチ",     add_to_opponent: nil,            },

          { key: "全駒",             add_to_opponent: "玉単騎",       },
          { key: "玉単騎",           add_to_opponent: nil,            },

          # 終局時の形勢
          { key: "屍の舞",         }, # 大駒すべて捨てて勝った
          { key: "穴熊の姿焼き",   }, # 相手が穴熊を残した状態で圧倒的な差で負かした
          { key: "名人に定跡なし", }, # 定跡なしで勝った

          # 詰み形
          { key: "都詰め",         },
          { key: "雪隠詰め",       },
          { key: "吊るし桂",       },
        ]
      end

      class_attribute :human_name, default: "手筋"

      include TagMethods
    end
  end
end
