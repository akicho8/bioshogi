# frozen-string-literal: true

module Bushido
  class AttackInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: "新米長玉", wars_code: "2015", turn_limit: nil, my_side_only: false, compare_condition: :equal, turn_eq: 2, only_location_key: nil},

#       {
#         key: "角換わり",
#         wars_code: "2000",
#         uragoya_url: "http://mijinko83.blog110.fc2.com/blog-entry-200.html",
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
#         uragoya_url: "http://mijinko83.blog110.fc2.com/blog-entry-139.html",
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
#         uragoya_url: "http://mijinko83.blog110.fc2.com/blog-entry-150.html",
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
#         uragoya_url: "http://mijinko83.blog110.fc2.com/blog-entry-149.html",
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
#         uragoya_url: "http://mijinko83.blog110.fc2.com/blog-entry-147.html",
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
  end
end
# ~> -:3:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:3:in `<main>'
