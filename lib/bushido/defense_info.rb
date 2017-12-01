# frozen-string-literal: true

module Bushido
  class DefenseInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: "金矢倉", shogi_wars_code: "001", form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-89.html",},
#       {
#         key: "カニ囲い",
#         shogi_wars_code: "000",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-88.html",
#         url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/kanigakoi.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 歩 歩 歩 ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ 金 銀 金 ・ ・ ・ ・|八
# | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },

#       {
#         key: "銀矢倉",
#         shogi_wars_code: "002",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-90.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 銀 ・ ・ ・ ・ ・|七
# | ・ 玉 金 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "片矢倉",
#         shogi_wars_code: "003",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-91.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 金 ・ ・ ・ ・ ・|七
# | ・ ・ 玉 金 ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "総矢倉",
#         shogi_wars_code: "004",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-92.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 金 銀 ・ ・ ・ ・|七
# | ・ 玉 金 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "矢倉穴熊",
#         shogi_wars_code: "005",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-93.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 金 ・ ・ ・ ・ ・|七
# | 香 ・ 金 ・ ・ ・ ・ ・ ・|八
# | 玉 ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "菊水穴熊",
#         shogi_wars_code: "006",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-94.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|七
# | ・ 銀 金 ・ ・ ・ ・ ・ ・|八
# | 香 玉 ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "銀立ち矢倉",
#         shogi_wars_code: "007",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-95.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 ・ ・ ・ ・ ・ ・|六
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|七
# | ・ 玉 金 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "菱矢倉",
#         shogi_wars_code: "008",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-96.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ 銀 ・ ・ ・ ・ ・|六
# | ・ ・ 銀 金 ・ ・ ・ ・ ・|七
# | ・ 玉 金 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "雁木囲い",
#         shogi_wars_code: "009",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-97.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ 銀 銀 ・ ・ ・ ・|七
# | ・ ・ 金 ・ 金 ・ ・ ・ ・|八
# | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "ボナンザ囲い",
#         shogi_wars_code: "010",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-98.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 銀 ・ ・ ・ ・ ・ ・|七
# | ・ ・ 玉 金 金 ・ ・ ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "美濃囲い",
#         shogi_wars_code: "100",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-99.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ 歩 ・|七
# | ・ ・ ・ ・ 金 ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "高美濃囲い",
#         shogi_wars_code: "101",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-99.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ 金 ・ 歩 ・|七
# | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "銀冠",
#         shogi_wars_code: "102",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-101.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ 金 ・|七
# | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "銀美濃",
#         shogi_wars_code: "103",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-102.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ 銀 ・ ・ ・|七
# | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "ダイヤモンド美濃",
#         shogi_wars_code: "104",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-103.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ 銀 ・ ・ ・|七
# | ・ ・ ・ ・ 金 ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "木村美濃",
#         shogi_wars_code: "105",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-104.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ 銀 ・ ・ ・|七
# | ・ ・ ・ ・ ・ ・ 金 玉 ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "片美濃囲い",
#         shogi_wars_code: "106",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-105.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ 歩 ・|七
# | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#
#       {
#         key: "ちょんまげ美濃",
#         shogi_wars_code: "107",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-106.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ 歩 ・|六
# | ・ ・ ・ ・ ・ ・ 歩 ・ ・|七
# | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
# | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       #   {
#       #     key: "坊主美濃",
#       #     shogi_wars_code: "108",
#       #     form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-107.html",
#       #     defense_p: true,
#       #     board_body: <<~EOT,
#       # +---------------------------+
#       # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
#       # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
#       # | ・ ・ ・ ・ ・ ・ 歩 ・ ・|七
#       # | ・ ・ ・ ・ ・ ・ 銀 玉 ・|八
#       # | ・ ・ ・ ・ ・ 金 ・ ・ ・|九
#       # +---------------------------+
#       # EOT
#       #   },
#       {
#         key: "左美濃",
#         shogi_wars_code: "200",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-108.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ 玉 銀 ・ 金 ・ ・ ・ ・|八
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "天守閣美濃",
#         shogi_wars_code: "201",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-109.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# | ・ 玉 ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ 銀 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "四枚美濃",
#         shogi_wars_code: "202",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-110.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ 玉 銀 金 ・ ・ ・ ・ ・|七
# | ・ ・ 銀 ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "舟囲い",
#         shogi_wars_code: "300",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-111.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 歩 ・ 歩 ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ 玉 ・ 金 銀 ・ ・ ・|八
# | ・ ・ 銀 金 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "居飛車穴熊",
#         shogi_wars_code: "301",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-112.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | 香 銀 ・ ・ ・ ・ ・ ・ ・|八
# | 玉 桂 金 ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "松尾流穴熊",
#         shogi_wars_code: "302",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-113.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ 金 ・ ・ ・ ・ ・|七
# | 香 銀 金 ・ ・ ・ ・ ・ ・|八
# | 玉 桂 銀 ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "銀冠穴熊",
#         shogi_wars_code: "303",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-114.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# | ・ 銀 ・ ・ ・ ・ ・ ・ ・|七
# | 香 ・ 金 ・ ・ ・ ・ ・ ・|八
# | 玉 桂 ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "ビッグ４",
#         shogi_wars_code: "304",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-115.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ 銀 銀 ・ ・ ・ ・ ・ ・|七
# | 香 金 金 ・ ・ ・ ・ ・ ・|八
# | 玉 桂 ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "箱入り娘",
#         shogi_wars_code: "305",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-116.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 玉 金 ・ ・ ・ ・ ・|八
# | ・ ・ 銀 金 ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "ミレニアム囲い",
#         shogi_wars_code: "306",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-117.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ 銀 ・ ・ ・ ・ ・ ・ ・|八
# | ・ 玉 金 ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "振り飛車穴熊",
#         shogi_wars_code: "400",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-118.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ 銀 香|八
# | ・ ・ ・ ・ ・ ・ 金 桂 玉|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "右矢倉",
#         shogi_wars_code: "401",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-119.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ 銀 ・ ・|七
# | ・ ・ ・ ・ ・ ・ 金 玉 ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "金無双",
#         shogi_wars_code: "402",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-120.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ 金 金 玉 銀 ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "中住まい",
#         shogi_wars_code: "403",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-121.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ 金 ・ 玉 銀 金 ・ ・|八
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "中原玉",
#         shogi_wars_code: "404",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-122.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ 銀 金 ・ ・ 銀 ・ ・ ・|八
# | ・ ・ ・ 玉 金 ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
#       {
#         key: "アヒル囲い",
#         shogi_wars_code: "500",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-123.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ ・ 銀 玉 銀 ・ ・ ・|八
# | ・ ・ 金 ・ ・ ・ 金 ・ ・|九
# +---------------------------+
# EOT
#       },
#
#       {
#         key: "いちご囲い",
#         shogi_wars_code: "501",
#         form_check_url: "http://mijinko83.blog110.fc2.com/blog-entry-124.html",
#         defense_p: true,
#         board_body: <<~EOT,
# +---------------------------+
# | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ 金 玉 金 ・ ・ ・ ・|八
# | ・ ・ 銀 ・ ・ ・ ・ ・ ・|九
# +---------------------------+
# EOT
#       },
    ]

    include TeaiwariInfo::DelegateToShapeInfoMethods
  end
end
