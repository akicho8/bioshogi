# frozen-string-literal: true

module Bushido
  class AttackInfo
    include ApplicationMemoryRecord
    memory_record [
#       {
#         key: "３七銀戦法",
#         shogi_wars_code: "2000",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-139.html",
#         attack_p: true,
#         board_body: <<~BOARD,
# +---------------------------+
# | ・ ・ 銀 ・ ・ ・ 銀 ・ ・|七
# | ・ ・ 金 ・ ・ ・ ・ 飛 ・|八
# | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
# +---------------------------+
# BOARD
#       },
#       {
#         key: "森下システム",
#         shogi_wars_code: "2003",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-150.html",
#         attack_p: true,
#         board_body: <<~BOARD,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ 桂 ・ ・|七
# | ・ ・ 金 ・ 金 銀 飛 ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# BOARD
#       },
#       {
#         key: "雀刺し",
#         shogi_wars_code: "2004",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-149.html",
#         attack_p: true,
#         board_body: <<~BOARD,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・ 香|七
# | ・ ・ 金 ・ 金 ・ ・ ・ 飛|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# BOARD
#       },
#       {
#         key: "米長流急戦矢倉",
#         shogi_wars_code: "2005",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-147.html",
#         attack_p: true,
#         board_body: <<~BOARD,
# +---------------------------+
# | ・ ・ ・ 銀 歩 ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ 角 金 ・ 金 ・ ・ ・ ・|八
# | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
# +---------------------------+
# BOARD
#       },
    ]

    include TeaiwariInfo::BasicMethods
  end
end
