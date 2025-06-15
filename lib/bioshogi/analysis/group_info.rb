# frozen-string-literal: true

module Bioshogi
  module Analysis
    class GroupInfo
      include ApplicationMemoryRecord
      memory_record [
        # -------------------------------------------------------------------------------- 戦法
        # 2
        { key: "棒銀",       },
        { key: "早繰り銀",   },
        { key: "腰掛け銀",   },

        { key: "角換わり",   },
        { key: "相掛かり",   },
        { key: "横歩取り",   },
        { key: "引き角",     },
        { key: "筋違い角",   },
        { key: "矢倉",       },
        { key: "右玉",       },
        { key: "風車",       },
        { key: "アヒル",     },

        # 3
        { key: "袖飛車",     },

        # 4
        { key: "右四間飛車", },

        # 5
        { key: "中飛車",     },

        # 6
        { key: "四間飛車",   },

        # 7
        { key: "三間飛車",   },
        { key: "石田流",     },
        { key: "鬼殺し",     },

        # 8
        { key: "向かい飛車", },

        # -------------------------------------------------------------------------------- 手筋
        { key: "ロケット",   },
      ]

      def values
        @values ||= TagIndex.values.find_all { |e| e.group_info === self }
      end
    end
  end
end
