require "./example_helper"

rows = TacticInfo.flat_map do |tactic_info|
  tactic_info.model.collect do |e|
    {
      "モデル"         => e.class.name,
      "名前"           => e.name,
      "親"             => e.parent ? e.parent.key : nil,
      "子供"           => e.children.collect(&:key).join(" "),
      "指定駒数"       => e.sorted_soldiers.count,
      # "配置"           => e.board_parser.sorted_soldiers.collect(&:name).join(" "),
      # "空升指定"       => e.board_parser.other_objects.find_all{|e|e[:something] == "○"}.collect{|e|e[:place].name}.join(" "),
    }
  end
end
tp rows
# >> |---------------------+----------------------+------------------+------------------------------------------------+----------|
# >> | モデル              | 名前                 | 親               | 子供                                           | 指定駒数 |
# >> |---------------------+----------------------+------------------+------------------------------------------------+----------|
# >> | Warabi::DefenseInfo | カニ囲い             |                  |                                                |        7 |
# >> | Warabi::DefenseInfo | 金矢倉               |                  | 総矢倉 菱矢倉                                  |        4 |
# >> | Warabi::DefenseInfo | 銀矢倉               |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 片矢倉               |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 総矢倉               | 金矢倉           |                                                |        5 |
# >> | Warabi::DefenseInfo | 矢倉穴熊             |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | 菊水矢倉             |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | 銀立ち矢倉           |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 菱矢倉               | 金矢倉           |                                                |        5 |
# >> | Warabi::DefenseInfo | 雁木囲い             |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | ボナンザ囲い         |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 矢倉早囲い           |                  |                                                |        2 |
# >> | Warabi::DefenseInfo | 美濃囲い             | 片美濃囲い       | 高美濃囲い ダイヤモンド美濃                    |        5 |
# >> | Warabi::DefenseInfo | 高美濃囲い           | 美濃囲い         |                                                |        5 |
# >> | Warabi::DefenseInfo | 銀冠                 |                  |                                                |        3 |
# >> | Warabi::DefenseInfo | 銀美濃               | 片美濃囲い       |                                                |        4 |
# >> | Warabi::DefenseInfo | ダイヤモンド美濃     | 美濃囲い         |                                                |        5 |
# >> | Warabi::DefenseInfo | 木村美濃             |                  |                                                |        3 |
# >> | Warabi::DefenseInfo | 片美濃囲い           |                  | 美濃囲い 銀美濃 ちょんまげ美濃                 |        4 |
# >> | Warabi::DefenseInfo | ちょんまげ美濃       | 片美濃囲い       | 坊主美濃                                       |        5 |
# >> | Warabi::DefenseInfo | 坊主美濃             | ちょんまげ美濃   |                                                |        4 |
# >> | Warabi::DefenseInfo | 金美濃               |                  |                                                |        6 |
# >> | Warabi::DefenseInfo | 左美濃               |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 天守閣美濃           |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 四枚美濃             |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | 端玉銀冠             |                  |                                                |        3 |
# >> | Warabi::DefenseInfo | 串カツ囲い           |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 舟囲い               |                  | 箱入り娘                                       |        8 |
# >> | Warabi::DefenseInfo | 居飛車穴熊           |                  | 松尾流穴熊                                     |        5 |
# >> | Warabi::DefenseInfo | 松尾流穴熊           | 居飛車穴熊       |                                                |        7 |
# >> | Warabi::DefenseInfo | 銀冠穴熊             |                  |                                                |        6 |
# >> | Warabi::DefenseInfo | ビッグ４             |                  |                                                |        7 |
# >> | Warabi::DefenseInfo | 箱入り娘             | 舟囲い           |                                                |        4 |
# >> | Warabi::DefenseInfo | ミレニアム囲い       |                  |                                                |        3 |
# >> | Warabi::DefenseInfo | 振り飛車穴熊         |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | 右矢倉               |                  |                                                |        3 |
# >> | Warabi::DefenseInfo | 金無双               |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 中住まい             |                  |                                                |        4 |
# >> | Warabi::DefenseInfo | 中原玉               |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | アヒル囲い           |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | いちご囲い           |                  |                                                |        5 |
# >> | Warabi::DefenseInfo | 無敵囲い             |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | ３七銀戦法           |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 脇システム           |                  |                                                |       17 |
# >> | Warabi::AttackInfo  | 矢倉棒銀             |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | 森下システム         |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 雀刺し               |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 米長流急戦矢倉       |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | カニカニ銀           |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 中原流急戦矢倉       |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 阿久津流急戦矢倉     |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 矢倉中飛車           |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 右四間飛車           |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 原始棒銀             |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 右玉                 |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | かまいたち戦法       |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | パックマン戦法       |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 新米長玉             |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 稲庭戦法             |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 四手角               |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 一間飛車             |                  | 一間飛車穴熊                                   |        2 |
# >> | Warabi::AttackInfo  | 一間飛車穴熊         | 一間飛車         |                                                |        2 |
# >> | Warabi::AttackInfo  | 都成流               |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 右四間飛車左美濃     |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 角換わり             |                  | 角換わり腰掛け銀 角換わり棒銀 角換わり早繰り銀 |        2 |
# >> | Warabi::AttackInfo  | 角換わり腰掛け銀     | 角換わり         | 木村定跡                                       |        2 |
# >> | Warabi::AttackInfo  | 角換わり棒銀         | 角換わり         |                                                |        1 |
# >> | Warabi::AttackInfo  | 角換わり早繰り銀     | 角換わり         |                                                |       10 |
# >> | Warabi::AttackInfo  | 筋違い角             |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 木村定跡             | 角換わり腰掛け銀 |                                                |       16 |
# >> | Warabi::AttackInfo  | 一手損角換わり       |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 相掛かり             |                  |                                                |        9 |
# >> | Warabi::AttackInfo  | 相掛かり棒銀         |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 塚田スペシャル       |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 中原流相掛かり       |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 中原飛車             |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 腰掛け銀             |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 鎖鎌銀               |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | ８五飛車戦法         |                  |                                                |        9 |
# >> | Warabi::AttackInfo  | UFO銀                |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 横歩取り             |                  |                                                |        8 |
# >> | Warabi::AttackInfo  | △３三角型空中戦法   |                  |                                                |       10 |
# >> | Warabi::AttackInfo  | △３三桂戦法         |                  |                                                |       10 |
# >> | Warabi::AttackInfo  | △２三歩戦法         |                  |                                                |       12 |
# >> | Warabi::AttackInfo  | △４五角戦法         |                  |                                                |       10 |
# >> | Warabi::AttackInfo  | 相横歩取り           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | ゴキゲン中飛車       |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | ツノ銀中飛車         |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 平目                 |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 風車                 |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 新風車               |                  |                                                |        8 |
# >> | Warabi::AttackInfo  | 英ちゃん流中飛車     |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 原始中飛車           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 加藤流袖飛車         |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | ５七金戦法           |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 超急戦               |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 中飛車左穴熊         |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 遠山流               |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 四間飛車             |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 藤井システム         |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | 立石流               |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | レグスペ             |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 三間飛車             |                  | 石田流 早石田 中田功XP                         |        0 |
# >> | Warabi::AttackInfo  | 石田流               | 三間飛車         |                                                |        3 |
# >> | Warabi::AttackInfo  | 早石田               | 三間飛車         | 升田式石田流                                   |        3 |
# >> | Warabi::AttackInfo  | 升田式石田流         | 早石田           |                                                |        3 |
# >> | Warabi::AttackInfo  | 鬼殺し               |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | △３ニ飛戦法         |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 中田功XP             | 三間飛車         |                                                |        3 |
# >> | Warabi::AttackInfo  | 真部流               |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | ▲７八飛戦法         |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | ４→３戦法           |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 楠本式石田流         |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 新石田流             |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 新鬼殺し             |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | ダイレクト向かい飛車 |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 向かい飛車           |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | メリケン向かい飛車   |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 阪田流向飛車         |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 角頭歩戦法           |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 鬼殺し向かい飛車     |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 陽動振り飛車         |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 玉頭銀               |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | つくつくぼうし戦法   |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | ひねり飛車           |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 相振り飛車           |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 角交換振り飛車       |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | きｍきｍ金           |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | ポンポン桂           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | ５筋位取り           |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 玉頭位取り           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 地下鉄飛車           |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 飯島流引き角戦法     |                  |                                                |        2 |
# >> | Warabi::AttackInfo  | 丸山ワクチン         |                  | 新丸山ワクチン                                 |        7 |
# >> | Warabi::AttackInfo  | 新丸山ワクチン       | 丸山ワクチン     |                                                |        8 |
# >> | Warabi::AttackInfo  | ４六銀左急戦         |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | ４五歩早仕掛け       |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 鷺宮定跡             |                  |                                                |        6 |
# >> | Warabi::AttackInfo  | 棒銀                 |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | ４六銀右急戦         |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 左美濃急戦           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 右四間飛車急戦       |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | 鳥刺し               |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | 嬉野流               |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 棒金                 |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 超速                 |                  |                                                |        5 |
# >> | Warabi::AttackInfo  | 対振り持久戦         |                  |                                                |        1 |
# >> | Warabi::AttackInfo  | 高田流左玉           |                  |                                                |        3 |
# >> | Warabi::AttackInfo  | ７二飛亜急戦         |                  |                                                |        7 |
# >> | Warabi::AttackInfo  | 袖飛車               |                  |                                                |        0 |
# >> | Warabi::AttackInfo  | 一直線穴熊           |                  |                                                |        8 |
# >> | Warabi::AttackInfo  | 穴角戦法             |                  | 穴角向かい飛車                                 |        0 |
# >> | Warabi::AttackInfo  | 穴角向かい飛車       | 穴角戦法         |                                                |        1 |
# >> | Warabi::AttackInfo  | うっかり三間飛車     |                  |                                                |        4 |
# >> | Warabi::AttackInfo  | アヒル戦法           |                  |                                                |        7 |
# >> |---------------------+----------------------+------------------+------------------------------------------------+----------|
