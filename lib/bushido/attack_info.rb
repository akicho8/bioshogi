# frozen-string-literal: true

module Bushido
  class AttackInfo
    include ApplicationMemoryRecord
    memory_record [
      {sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-200.html", wars_code: "2015", key: "新米長玉", evolution_keys: nil, turn_limit: nil, compare_my_side_only: false, compare_condition: :equal,   turn_eq: 2,   only_location_key: nil, trigger1: nil, process_ki2: "▲７六歩 △６二玉", },
      {sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-198.html", wars_code: "2300", key: "横歩取り", evolution_keys: nil, turn_limit: nil, compare_my_side_only: false, compare_condition: :include, turn_eq: nil, only_location_key: nil, trigger1: "▲３四飛", process_ki2: "▲７六歩 △３四歩 ▲２六歩 △８四歩 ▲２五歩 △８五歩 ▲７八金 △３二金 ▲２四歩 △同歩 ▲同飛 △８六歩 ▲同歩 △同飛 ▲３四飛", },

      #       {
      #         key: "角換わり",
      #         wars_code: "2000",
      #         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-200.html",
      #         attack_p: true,
      #         board_body: <<~EOT,
      # +---------------------------+
      # | ・ ・ 銀 ・ ・ ・ 銀 ・ ・|七
      # | ・ ・ 金 ・ ・ ・ ・ 飛 ・|八
      # | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #       },

      #       {
      #         key: "３七銀戦法",
      #         wars_code: "2000",
      #         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-139.html",
      #         attack_p: true,
      #         board_body: <<~EOT,
      # +---------------------------+
      # | ・ ・ 銀 ・ ・ ・ 銀 ・ ・|七
      # | ・ ・ 金 ・ ・ ・ ・ 飛 ・|八
      # | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #       },
      #       {
      #         key: "森下システム",
      #         wars_code: "2003",
      #         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-150.html",
      #         attack_p: true,
      #         board_body: <<~EOT,
      # +---------------------------+
      # | ・ ・ ・ ・ ・ ・ 桂 ・ ・|七
      # | ・ ・ 金 ・ 金 銀 飛 ・ ・|八
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #       },
      #       {
      #         key: "雀刺し",
      #         wars_code: "2004",
      #         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-149.html",
      #         attack_p: true,
      #         board_body: <<~EOT,
      # +---------------------------+
      # | ・ ・ ・ ・ ・ ・ ・ ・ 香|七
      # | ・ ・ 金 ・ 金 ・ ・ ・ 飛|八
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #       },
      #       {
      #         key: "米長流急戦矢倉",
      #         wars_code: "2005",
      #         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-147.html",
      #         attack_p: true,
      #         board_body: <<~EOT,
      # +---------------------------+
      # | ・ ・ ・ 銀 歩 ・ ・ ・ ・|六
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
      # | ・ 角 金 ・ 金 ・ ・ ・ ・|八
      # | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #       },
    ]

    include TeaiwariInfo::DelegateToShapeInfoMethods

    def evolution_keys
      Array(super)
    end

    def trigger1
      if super
        Soldier.from_str(super)
      end
    end

    def self_check
      if process_ki2
        info = Parser.parse(process_ki2)
        names = info.mediator.players.flat_map do |e|
          e.attack_infos.collect(&:name)
        end
        if names.include?(name)
          names
        end
      end
    end
  end
end
