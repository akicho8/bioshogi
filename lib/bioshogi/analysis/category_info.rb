# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CategoryInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "中飛車系",     },
        { key: "三間飛車系",   },
        { key: "四間飛車系",   },
        { key: "右四間飛車系", },
        { key: "横歩取り系",   },
        { key: "向かい飛車系", },
        { key: "右玉系",       },
        { key: "筋違い角系",   },
        { key: "角換わり系",   },
        { key: "相掛かり系",   },
        # { key: "引き角",     self_push: "引き角系",       opponent_push: "対引き角系",       },

        # { key: "中飛車",     self_push: "中飛車系",     opponent_push: "対中飛車系",   },
        # { key: "三間飛車",   self_push: "三間飛車系",   opponent_push: "対三間飛車系",   },
        # { key: "四間飛車",   self_push: "四間飛車系",   opponent_push: "対四間飛車系",   },
        # { key: "右四間飛車", self_push: "右四間飛車系", opponent_push: "対右四間飛車系", },
        # { key: "横歩取り",   self_push: "横歩取り系",   opponent_push: "対横歩取り系",   },
        # { key: "向かい飛車", self_push: "向かい飛車系", opponent_push: "対向かい飛車系", },
        # { key: "右玉",       self_push: "右玉系",       opponent_push: "対右玉系",       },
        # # { key: "引き角",     self_push: "引き角系",       opponent_push: "対引き角系",       },
        # { key: "筋違い角",   self_push: "筋違い角系",   opponent_push: "対筋違い角系",   },
        # { key: "角換わり",   self_push: "角換わり系",   opponent_push: "対角換わり系",   },
        # { key: "相掛かり",   self_push: "相掛かり系",   opponent_push: "対相掛かり系",   },
      ]

      def object
        @object ||= TacticInfo.flat_fetch(key)
      end
    end
  end
end
