require "./example_helper"

rows = SkillGroupInfo.flat_map do |skill_group_info|
  skill_group_info.model.collect do |e|
    {
      "モデル"         => e.class.name,
      "名前"           => e.name,
      "親"             => e.parent ? e.parent.key : nil,
      "子供"           => e.children.collect(&:key).join(" "),
      "指定駒数"       => e.sorted_soldiers.count,
      # "配置"           => e.board_parser.sorted_soldiers.collect(&:name).join(" "),
      # "空升指定"       => e.board_parser.other_objects.find_all{|e|e[:something] == "○"}.collect{|e|e[:point].name}.join(" "),
    }
  end
end
tp rows
# >> |----------------------+----------------------+------------+----------------------------+----------|
# >> | モデル               | 名前                 | 親         | 子供                       | 指定駒数 |
# >> |----------------------+----------------------+------------+----------------------------+----------|
# >> | Bushido::DefenseInfo | カニ囲い             |            |                            |        7 |
# >> | Bushido::DefenseInfo | 金矢倉               |            | 総矢倉 菱矢倉              |        4 |
# >> | Bushido::DefenseInfo | 銀矢倉               |            |                            |        4 |
# >> | Bushido::DefenseInfo | 片矢倉               |            |                            |        4 |
# >> | Bushido::DefenseInfo | 総矢倉               | 金矢倉     |                            |        5 |
# >> | Bushido::DefenseInfo | 矢倉穴熊             |            |                            |        5 |
# >> | Bushido::DefenseInfo | 菊水矢倉             |            |                            |        5 |
# >> | Bushido::DefenseInfo | 銀立ち矢倉           |            |                            |        4 |
# >> | Bushido::DefenseInfo | 菱矢倉               | 金矢倉     |                            |        5 |
# >> | Bushido::DefenseInfo | 雁木囲い             |            |                            |        5 |
# >> | Bushido::DefenseInfo | ボナンザ囲い         |            |                            |        4 |
# >> | Bushido::DefenseInfo | 美濃囲い             | 片美濃囲い | ダイヤモンド美濃           |        5 |
# >> | Bushido::DefenseInfo | 高美濃囲い           | 片美濃囲い |                            |        5 |
# >> | Bushido::DefenseInfo | 銀冠                 |            |                            |        3 |
# >> | Bushido::DefenseInfo | 銀美濃               | 片美濃囲い |                            |        4 |
# >> | Bushido::DefenseInfo | ダイヤモンド美濃     | 美濃囲い   |                            |        5 |
# >> | Bushido::DefenseInfo | 木村美濃             |            |                            |        3 |
# >> | Bushido::DefenseInfo | 片美濃囲い           |            | 美濃囲い 高美濃囲い 銀美濃 |        4 |
# >> | Bushido::DefenseInfo | ちょんまげ美濃       |            |                            |        5 |
# >> | Bushido::DefenseInfo | 坊主美濃             |            |                            |        4 |
# >> | Bushido::DefenseInfo | 左美濃               |            |                            |        4 |
# >> | Bushido::DefenseInfo | 天守閣美濃           |            |                            |        4 |
# >> | Bushido::DefenseInfo | 四枚美濃             |            |                            |        5 |
# >> | Bushido::DefenseInfo | 端玉銀冠             |            |                            |        3 |
# >> | Bushido::DefenseInfo | 串カツ囲い           |            |                            |        4 |
# >> | Bushido::DefenseInfo | 舟囲い               |            |                            |        8 |
# >> | Bushido::DefenseInfo | 居飛車穴熊           |            |                            |        5 |
# >> | Bushido::DefenseInfo | 松尾流穴熊           |            |                            |        7 |
# >> | Bushido::DefenseInfo | 銀冠穴熊             |            |                            |        6 |
# >> | Bushido::DefenseInfo | ビッグ４             |            |                            |        7 |
# >> | Bushido::DefenseInfo | 箱入り娘             |            |                            |        4 |
# >> | Bushido::DefenseInfo | ミレニアム囲い       |            |                            |        3 |
# >> | Bushido::DefenseInfo | 振り飛車穴熊         |            |                            |        5 |
# >> | Bushido::DefenseInfo | 右矢倉               |            |                            |        3 |
# >> | Bushido::DefenseInfo | 金無双               |            |                            |        4 |
# >> | Bushido::DefenseInfo | 中住まい             |            |                            |        4 |
# >> | Bushido::DefenseInfo | 中原玉               |            |                            |        5 |
# >> | Bushido::DefenseInfo | アヒル囲い           |            |                            |        5 |
# >> | Bushido::DefenseInfo | いちご囲い           |            |                            |        5 |
# >> | Bushido::AttackInfo  | ３七銀戦法           |            |                            |        4 |
# >> | Bushido::AttackInfo  | 脇システム           |            |                            |       38 |
# >> | Bushido::AttackInfo  | 矢倉棒銀             |            |                            |        6 |
# >> | Bushido::AttackInfo  | 森下システム         |            |                            |        5 |
# >> | Bushido::AttackInfo  | 雀刺し               |            |                            |        4 |
# >> | Bushido::AttackInfo  | 米長流急戦矢倉       |            |                            |        7 |
# >> | Bushido::AttackInfo  | カニカニ銀           |            |                            |        7 |
# >> | Bushido::AttackInfo  | 中原流急戦矢倉       |            |                            |        5 |
# >> | Bushido::AttackInfo  | 阿久津流急戦矢倉     |            |                            |        4 |
# >> | Bushido::AttackInfo  | 矢倉中飛車           |            |                            |        5 |
# >> | Bushido::AttackInfo  | 右四間飛車           |            |                            |        0 |
# >> | Bushido::AttackInfo  | 原始棒銀             |            |                            |        4 |
# >> | Bushido::AttackInfo  | 右玉                 |            |                            |        4 |
# >> | Bushido::AttackInfo  | かまいたち戦法       |            |                            |        6 |
# >> | Bushido::AttackInfo  | パックマン戦法       |            |                            |        1 |
# >> | Bushido::AttackInfo  | 新米長玉             |            |                            |        1 |
# >> | Bushido::AttackInfo  | 稲庭戦法             |            |                            |        4 |
# >> | Bushido::AttackInfo  | 四手角               |            |                            |        1 |
# >> | Bushido::AttackInfo  | 角換わり             |            |                            |        2 |
# >> | Bushido::AttackInfo  | 角換わり腰掛け銀     |            |                            |        3 |
# >> | Bushido::AttackInfo  | 角換わり早繰り銀     |            |                            |       10 |
# >> | Bushido::AttackInfo  | 筋違い角             |            |                            |        5 |
# >> | Bushido::AttackInfo  | 木村定跡             |            |                            |       16 |
# >> | Bushido::AttackInfo  | 一手損角換わり       |            |                            |        0 |
# >> | Bushido::AttackInfo  | 相掛かり             |            |                            |        9 |
# >> | Bushido::AttackInfo  | 相掛かり棒銀         |            |                            |        5 |
# >> | Bushido::AttackInfo  | 塚田スペシャル       |            |                            |        7 |
# >> | Bushido::AttackInfo  | 中原流相掛かり       |            |                            |        7 |
# >> | Bushido::AttackInfo  | 中原飛車             |            |                            |        5 |
# >> | Bushido::AttackInfo  | 腰掛け銀             |            |                            |        3 |
# >> | Bushido::AttackInfo  | 鎖鎌銀               |            |                            |        3 |
# >> | Bushido::AttackInfo  | ８五飛車戦法         |            |                            |        9 |
# >> | Bushido::AttackInfo  | 横歩取り             |            |                            |        8 |
# >> | Bushido::AttackInfo  | △３三角型空中戦法   |            |                            |       10 |
# >> | Bushido::AttackInfo  | △３三桂戦法         |            |                            |       10 |
# >> | Bushido::AttackInfo  | △４五角戦法         |            |                            |       10 |
# >> | Bushido::AttackInfo  | 相横歩取り           |            |                            |        3 |
# >> | Bushido::AttackInfo  | ゴキゲン中飛車       |            |                            |        3 |
# >> | Bushido::AttackInfo  | ツノ銀中飛車         |            |                            |        4 |
# >> | Bushido::AttackInfo  | 平目                 |            |                            |        4 |
# >> | Bushido::AttackInfo  | 風車                 |            |                            |        4 |
# >> | Bushido::AttackInfo  | 新風車               |            |                            |        7 |
# >> | Bushido::AttackInfo  | 英ちゃん流中飛車     |            |                            |        2 |
# >> | Bushido::AttackInfo  | 原始中飛車           |            |                            |        3 |
# >> | Bushido::AttackInfo  | 加藤流袖飛車         |            |                            |        6 |
# >> | Bushido::AttackInfo  | ５七金戦法           |            |                            |        4 |
# >> | Bushido::AttackInfo  | 超急戦               |            |                            |        7 |
# >> | Bushido::AttackInfo  | 四間飛車             |            |                            |        1 |
# >> | Bushido::AttackInfo  | 藤井システム         |            |                            |        6 |
# >> | Bushido::AttackInfo  | 立石流               |            |                            |        4 |
# >> | Bushido::AttackInfo  | レグスペ             |            |                            |        3 |
# >> | Bushido::AttackInfo  | 三間飛車             |            |                            |        0 |
# >> | Bushido::AttackInfo  | 石田流               |            |                            |        3 |
# >> | Bushido::AttackInfo  | 早石田               |            |                            |        3 |
# >> | Bushido::AttackInfo  | 升田式石田流         |            |                            |        3 |
# >> | Bushido::AttackInfo  | 鬼殺し               |            |                            |        2 |
# >> | Bushido::AttackInfo  | △３ニ飛戦法         |            |                            |        0 |
# >> | Bushido::AttackInfo  | 中田功ＸＰ           |            |                            |        5 |
# >> | Bushido::AttackInfo  | 真部流               |            |                            |        6 |
# >> | Bushido::AttackInfo  | ▲７八飛戦法         |            |                            |        1 |
# >> | Bushido::AttackInfo  | ４→３戦法           |            |                            |        0 |
# >> | Bushido::AttackInfo  | 楠本式石田流         |            |                            |        7 |
# >> | Bushido::AttackInfo  | 新石田流             |            |                            |        3 |
# >> | Bushido::AttackInfo  | 新鬼殺し             |            |                            |        4 |
# >> | Bushido::AttackInfo  | ダイレクト向かい飛車 |            |                            |        1 |
# >> | Bushido::AttackInfo  | 向飛車               |            |                            |        0 |
# >> | Bushido::AttackInfo  | メリケン向かい飛車   |            |                            |        4 |
# >> | Bushido::AttackInfo  | 阪田流向飛車         |            |                            |        1 |
# >> | Bushido::AttackInfo  | 角頭歩戦法           |            |                            |        2 |
# >> | Bushido::AttackInfo  | 鬼殺し向かい飛車     |            |                            |        3 |
# >> | Bushido::AttackInfo  | 陽動振り飛車         |            |                            |        2 |
# >> | Bushido::AttackInfo  | つくつくぼうし戦法   |            |                            |        4 |
# >> | Bushido::AttackInfo  | 相振り飛車           |            |                            |        4 |
# >> | Bushido::AttackInfo  | ポンポン桂           |            |                            |        3 |
# >> | Bushido::AttackInfo  | ５筋位取り           |            |                            |        1 |
# >> | Bushido::AttackInfo  | 玉頭位取り           |            |                            |        3 |
# >> | Bushido::AttackInfo  | 地下鉄飛車           |            |                            |        0 |
# >> | Bushido::AttackInfo  | 飯島流引き角戦法     |            |                            |        2 |
# >> | Bushido::AttackInfo  | 丸山ワクチン         |            |                            |        8 |
# >> | Bushido::AttackInfo  | ４六銀左急戦         |            |                            |        4 |
# >> | Bushido::AttackInfo  | ４五歩早仕掛け       |            |                            |        5 |
# >> | Bushido::AttackInfo  | 鷺宮定跡             |            |                            |        6 |
# >> | Bushido::AttackInfo  | ４六銀右急戦         |            |                            |        3 |
# >> | Bushido::AttackInfo  | 左美濃急戦           |            |                            |        3 |
# >> | Bushido::AttackInfo  | 右四間飛車急戦       |            |                            |        4 |
# >> | Bushido::AttackInfo  | 鳥刺し               |            |                            |        3 |
# >> | Bushido::AttackInfo  | 嬉野流               |            |                            |        0 |
# >> | Bushido::AttackInfo  | 棒金                 |            |                            |        1 |
# >> | Bushido::AttackInfo  | 超速                 |            |                            |        5 |
# >> |----------------------+----------------------+------------+----------------------------+----------|
