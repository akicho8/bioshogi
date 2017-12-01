# frozen-string-literal: true

require_relative "shape_info"

module Bushido
  class AttackInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: "新米長玉", shogi_wars_code: "2015", tesuu_limit_ika: nil, jibungawadake: false, jouken_dousuru: "equal", nantemeka: 2, only_location_key: nil},

#       {
#         key: "角換わり",
#         shogi_wars_code: "2000",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-200.html",
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
#         shogi_wars_code: "2000",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-139.html",
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
#         shogi_wars_code: "2003",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-150.html",
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
#         shogi_wars_code: "2004",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-149.html",
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
#         shogi_wars_code: "2005",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-147.html",
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
