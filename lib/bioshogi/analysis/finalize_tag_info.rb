# frozen-string-literal: true

# |-----------------+------------------------------------|
# | turn_gteq       | N手以上である                      |
# | hirate_like     | 平手風の開始局面から始まっている   |
# | critical        | 駒が衝突した (角と歩も含む)        |
# | outbreak        | 駒が衝突した (角と歩を除く)        |
# | checkmate       | 最後は詰みである                   |
# |-----------------+------------------------------------|
#
# - 順序重要
# - 相や対で始まるものは関連するタグに対応して必ず決まるので他の条件は要らない
#
module Bioshogi
  module Analysis
    class FinalizeTagInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "名人に定跡なし", turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "力戦より前", },
        { key: "力戦",           turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },

        { key: "居飛車",         turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },
        { key: "相居飛車",       turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },
        # { key: "対居飛車",       turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },
        { key: "相振り飛車",     turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },
        { key: "対抗形",         turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },

        { key: "居玉",           turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },
        { key: "相居玉",         turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },

        { key: "急戦・持久戦",   turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },
        { key: "短手数・長手数", turn_gteq: nil, preset_is: :hirate_like, critical: true, outbreak: nil,  checkmate: nil,  description: "",           },

        { key: "屍の舞",         turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },
        { key: "穴熊の姿焼き",     turn_gteq: nil, preset_is: :hirate_like, critical: nil,  outbreak: true, checkmate: nil,  description: "",           },

        { key: "相穴熊",         turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },
        { key: "相入玉",         turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },

        { key: "都詰め",         turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: true, description: "",           },
        { key: "吊るし桂",       turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: true, description: "",           },
        { key: "雪隠詰め",       turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: true, description: "",           },

        { key: "雁木削除",       turn_gteq: nil, preset_is: nil,          critical: nil,  outbreak: nil,  checkmate: nil,  description: "",           },
      ]

      def func
        @func ||= FinalizeTagFuncInfo.fetch(key).func
      end
    end
  end
end
