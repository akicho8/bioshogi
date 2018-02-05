# frozen-string-literal: true

module Warabi
  class DefenseGroupInfo
    include ApplicationMemoryRecord
    memory_record [
      # 居飛車
      {key: "基本的な囲い",       },
      {key: "矢倉変化形",         },
      {key: "穴熊変化形",         },
      {key: "自陣全体を守る囲い", },
      {key: "その他の囲い",       },
    ]
  end
end
