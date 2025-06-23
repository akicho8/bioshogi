# frozen-string-literal: true

# 判定は kill_count_lteq,  :pawn_have_ok しか使ってない

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

          {
            key: "歩偏執者",
            if_capture_then: -> {
              # 【却下条件】取った駒は歩である
              and_cond { captured_soldier.piece.key == :pawn }

              # 【却下条件】すでに持っている
              skip_if { player.tag_bundle.has_tag?(TagIndex.fetch("歩偏執者")) }

              # 【却下条件】敵が歩を持っている
              skip_if { opponent_player.piece_box.has_key?(:pawn) }

              # 【必要条件】盤上に敵の歩が一枚もない
              and_cond { opponent_player.soldiers_lookup(:pawn).empty?  }
            },
          },

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
        ]
      end

      class_attribute :human_name, default: "手筋"

      include TagBase
    end
  end
end
