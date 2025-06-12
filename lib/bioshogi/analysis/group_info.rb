# frozen-string-literal: true

module Bioshogi
  module Analysis
    class GroupInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "三間飛車",   },
        { key: "鬼殺し",     },
        { key: "石田流",     },
        { key: "四間飛車",   },
        { key: "右四間飛車", },
        { key: "中飛車",     },
        { key: "横歩取り",   },
        { key: "向かい飛車", },
        { key: "引き角",     },
        { key: "筋違い角",   },
        { key: "角換わり",   },
        { key: "相掛かり",   },
        { key: "右玉",       },
        { key: "矢倉",       },
        { key: "袖飛車",     },
        { key: "棒銀",       },
        { key: "早繰り銀",   },
        { key: "腰掛け銀",   },
        { key: "アヒル",     },
        { key: "風車",       },
      ]

      def values
        @values ||= TacticInfo.all_elements.find_all { |e| e.group_info === self }
      end
    end
  end
end
