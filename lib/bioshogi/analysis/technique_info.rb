# frozen-string-literal: true

module Bioshogi
  module Analysis
    class TechniqueInfo
      include ApplicationMemoryRecord
      memory_record attr_reader: TagColumnNames do
        [
          # 歩
          { key: "突き捨て",          },
          { key: "垂れ歩",            },
          { key: "たたきの歩",        },
          { key: "継ぎ歩",            },
          { key: "連打の歩",          },
          { key: "蓋歩",              },
          { key: "歩裏の歩",          },
          { key: "突き違いの歩",      },
          { key: "こびん攻め",        },
          { key: "桂頭攻め",          },
          { key: "角頭攻め",          },
          { key: "玉頭攻め",          },
          { key: "端攻め",            },
          { key: "端玉には端歩",      },
          { key: "ポーンハンター",    },
          { key: "パンドラの歩", },

          # 歩 (マイナス)
          { key: "居飛車の税金", outbreak_skip: true, },
          { key: "金底の歩",   },
          { key: "土下座の歩", },
          { key: "歩切れ",     },

          # と
          { key: "勝ち確5三と",  alias_names: "5三のと金に負けなし",  },
          { key: "歩の錬金術師", },
          { key: "と金攻め",     },
          { key: "マムシのと金", },

          # 香
          { key: "田楽刺し",                                          },
          { key: "下段の香",                                          },
          { key: "歩裏の香",                                          },
          { key: "底歩に香",                                          },
          # 香 + 飛 (特別判定)
          { key: "ロケット",    group_key: "ロケット",                },
          { key: "2段ロケット", group_key: "ロケット",                },
          { key: "3段ロケット", group_key: "ロケット",                },
          { key: "4段ロケット", group_key: "ロケット",                },
          { key: "5段ロケット", group_key: "ロケット",                },
          { key: "6段ロケット", group_key: "ロケット",                },
          { key: "封香連舞",                                          },

          # 桂
          { key: "ふんどしの桂", },
          { key: "控えの桂",     },
          { key: "継ぎ桂",       },
          { key: "急所の桂",     },
          { key: "高跳びの桂",   },
          { key: "跳ね違いの桂", },
          { key: "パンツを脱ぐ", },
          { key: "歩頭の桂",     },
          { key: "金頭の桂",     },
          { key: "桂頭の桂",     },
          { key: "三桂懐刃",     },

          # 銀
          { key: "割り打ちの銀", },
          { key: "たすきの銀",   },
          { key: "位の確保",     },
          { key: "銀ばさみ",     },
          { key: "桂頭の銀",     },
          { key: "銀不成",       },

          { key: "壁銀",         },
          { key: "頭銀",         },
          { key: "腹銀",         },
          { key: "尻銀",         },
          { key: "肩銀",         },
          { key: "裾銀",         },

          # 金
          { key: "堅陣の金",     },
          { key: "退場の金",     },
          { key: "壁金",         },
          { key: "頭金",         },
          { key: "腹金",         },
          { key: "尻金",         },
          { key: "肩金",         },
          { key: "裾金",         },

          # 金銀
          { key: "穴熊再生",   },

          # 角
          { key: "幽霊角",           },
          { key: "遠見の角",         },
          { key: "たすきの角",       },
          { key: "自陣角",           },
          { key: "守りの馬",         },
          { key: "双馬結界",         },
          { key: "角不成",           },
          { key: "角切り",           },
          { key: "馬切り",           },
          { key: "序盤は飛車より角", },
          { key: "角交換",           },
          { key: "手得",             },
          { key: "手損",             },

          # 飛
          { key: "飛車先交換", },
          { key: "浮き飛車",   },
          { key: "自陣飛車",   },
          { key: "二枚飛車",   },
          { key: "一間竜",     },
          { key: "飛車不成",   },
          { key: "飛車切り",   },
          { key: "竜切り",     },

          # 飛角
          { key: "双竜双馬陣", },
          { key: "空中戦", add_to_opponent: "空中戦", },

          # 玉
          { key: "端玉",                                              },
          { key: "ハッチ閉鎖",                                        },
          { key: "玉飛接近",                                          },
          { key: "銀冠の小部屋",                                      },
          { key: "裸玉",                                              },
          { key: "桂頭の玉",                                          },
          { key: "中段玉",                                            },
          { key: "双玉接近",        add_to_opponent: "双玉接近",      },
          { key: "入玉",                                              },

          # 対局時の状況
          { key: "駒柱",             add_to_opponent: "駒柱",         },

          { key: "大駒コンプリート", add_to_opponent: "大駒全ブッチ", },
          { key: "大駒全ブッチ",                                      },

          { key: "全駒",             add_to_opponent: "玉単騎",       },
          { key: "玉単騎",                                            },

          # 終局時の形勢
          { key: "屍の舞",                                            }, # 大駒すべて捨てて勝った
          { key: "穴熊の姿焼き",                                      }, # 相手が穴熊を残した状態で圧倒的な差で負かした
          { key: "名人に定跡なし",                                    }, # 定跡なしで勝った

          # 詰み形
          { key: "都詰め",                                            },
          { key: "雪隠詰め",                                          },
          { key: "吊るし桂",                                          },
        ]
      end

      class_attribute :human_name, default: "手筋"

      include TagMethods
    end
  end
end
