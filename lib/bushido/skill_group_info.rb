module Bushido
  class SkillGroupInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :defense, name: "囲い"},
      {key: :attack,  name: "戦型"},
    ]

    def model
      "bushido/#{key}_info".classify.constantize
    end

    def var_key
      "#{key}_infos"
    end
  end
end
