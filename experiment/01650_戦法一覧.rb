require "./setup"

rows = Explain::TacticInfo.flat_map do |tactic_info|
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
# >> | Bioshogi::DefenseInfo | カニ囲い             |                  |                                                |        7 |
# >> | Bioshogi::DefenseInfo | 金矢倉               |                  | 総矢倉 菱矢倉                                  |        4 |
# >> | Bioshogi::DefenseInfo | 銀矢倉               |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 片矢倉               |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 総矢倉               | 金矢倉           |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 矢倉穴熊             |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 菊水矢倉             |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 銀立ち矢倉           |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 菱矢倉               | 金矢倉           |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 雁木囲い             |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | ボナンザ囲い         |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 矢倉早囲い           |                  |                                                |        2 |
# >> | Bioshogi::DefenseInfo | 美濃囲い             | 片美濃囲い       | 高美濃囲い ダイヤモンド美濃                    |        5 |
# >> | Bioshogi::DefenseInfo | 高美濃囲い           | 美濃囲い         |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 銀冠                 |                  |                                                |        3 |
# >> | Bioshogi::DefenseInfo | 銀美濃               | 片美濃囲い       |                                                |        4 |
# >> | Bioshogi::DefenseInfo | ダイヤモンド美濃     | 美濃囲い         |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 木村美濃             |                  |                                                |        3 |
# >> | Bioshogi::DefenseInfo | 片美濃囲い           |                  | 美濃囲い 銀美濃 ちょんまげ美濃                 |        4 |
# >> | Bioshogi::DefenseInfo | ちょんまげ美濃       | 片美濃囲い       | 坊主美濃                                       |        5 |
# >> | Bioshogi::DefenseInfo | 坊主美濃             | ちょんまげ美濃   |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 金美濃               |                  |                                                |        6 |
# >> | Bioshogi::DefenseInfo | 左美濃               |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 天守閣美濃           |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 四枚美濃             |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 端玉銀冠             |                  |                                                |        3 |
# >> | Bioshogi::DefenseInfo | 串カツ囲い           |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 舟囲い               |                  | 箱入り娘                                       |        8 |
# >> | Bioshogi::DefenseInfo | 居飛車穴熊           |                  | 松尾流穴熊                                     |        5 |
# >> | Bioshogi::DefenseInfo | 松尾流穴熊           | 居飛車穴熊       |                                                |        7 |
# >> | Bioshogi::DefenseInfo | 銀冠穴熊             |                  |                                                |        6 |
# >> | Bioshogi::DefenseInfo | ビッグ4             |                  |                                                |        7 |
# >> | Bioshogi::DefenseInfo | 箱入り娘             | 舟囲い           |                                                |        4 |
# >> | Bioshogi::DefenseInfo | ミレニアム囲い       |                  |                                                |        3 |
# >> | Bioshogi::DefenseInfo | 振り飛車穴熊         |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 右矢倉               |                  |                                                |        3 |
# >> | Bioshogi::DefenseInfo | 金無双               |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 中住まい             |                  |                                                |        4 |
# >> | Bioshogi::DefenseInfo | 中原玉               |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | アヒル囲い           |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | いちご囲い           |                  |                                                |        5 |
# >> | Bioshogi::DefenseInfo | 無敵囲い             |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | ▲３七銀戦法           |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 脇システム           |                  |                                                |       17 |
# >> | Bioshogi::AttackInfo  | 矢倉棒銀             |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | 森下システム         |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 雀刺し               |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 米長流急戦矢倉       |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | カニカニ銀           |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 中原流急戦矢倉       |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 阿久津流急戦矢倉     |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 矢倉中飛車           |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 右四間飛車           |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 原始棒銀             |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 右玉                 |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | かまいたち戦法       |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | パックマン戦法       |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 新米長玉             |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 稲庭戦法             |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 四手角               |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 一間飛車             |                  | 一間飛車穴熊                                   |        2 |
# >> | Bioshogi::AttackInfo  | 一間飛車穴熊         | 一間飛車         |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 都成流△３一金               |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 右四間飛車左美濃     |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 角換わり             |                  | 角換わり腰掛け銀 角換わり棒銀 角換わり早繰り銀 |        2 |
# >> | Bioshogi::AttackInfo  | 角換わり腰掛け銀     | 角換わり         | 木村定跡                                       |        2 |
# >> | Bioshogi::AttackInfo  | 角換わり棒銀         | 角換わり         |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 角換わり早繰り銀     | 角換わり         |                                                |       10 |
# >> | Bioshogi::AttackInfo  | 筋違い角             |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 木村定跡             | 角換わり腰掛け銀 |                                                |       16 |
# >> | Bioshogi::AttackInfo  | 一手損角換わり       |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 相掛かり             |                  |                                                |        9 |
# >> | Bioshogi::AttackInfo  | 相掛かり棒銀         |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 塚田スペシャル       |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 中原流相掛かり       |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 中原飛車             |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 腰掛け銀             |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 鎖鎌銀               |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | ▲８五飛車戦法         |                  |                                                |        9 |
# >> | Bioshogi::AttackInfo  | UFO銀                |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 横歩取り             |                  |                                                |        8 |
# >> | Bioshogi::AttackInfo  | △３三角型空中戦法   |                  |                                                |       10 |
# >> | Bioshogi::AttackInfo  | △３三桂戦法         |                  |                                                |       10 |
# >> | Bioshogi::AttackInfo  | △２三歩戦法         |                  |                                                |       12 |
# >> | Bioshogi::AttackInfo  | △４五角戦法         |                  |                                                |       10 |
# >> | Bioshogi::AttackInfo  | 相横歩取り           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | ゴキゲン中飛車       |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | ツノ銀中飛車         |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 平目                 |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 風車                 |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 新風車               |                  |                                                |        8 |
# >> | Bioshogi::AttackInfo  | 英ちゃん流中飛車     |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 原始中飛車           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 加藤流袖飛車         |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | ▲５七金戦法           |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 超急戦               |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 中飛車左穴熊         |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 遠山流               |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 四間飛車             |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 藤井システム         |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | 立石流四間飛車               |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | レグスペ             |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 三間飛車             |                  | 石田流 早石田 中田功XP                         |        0 |
# >> | Bioshogi::AttackInfo  | 石田流               | 三間飛車         |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 早石田               | 三間飛車         | 升田式石田流                                   |        3 |
# >> | Bioshogi::AttackInfo  | 升田式石田流         | 早石田           |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 鬼殺し               |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 2手目△３ニ飛戦法         |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 中田功XP             | 三間飛車         |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 真部流               |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | ▲７八飛戦法         |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | ４→３戦法           |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 楠本式石田流         |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 新石田流             |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 新鬼殺し             |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | ダイレクト向かい飛車 |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 向かい飛車           |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | メリケン向かい飛車   |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 阪田流向飛車         |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 角頭歩戦法           |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 鬼殺し向かい飛車     |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 陽動振り飛車         |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 玉頭銀               |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | つくつくぼうし戦法   |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | ひねり飛車           |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 相振り飛車           |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 角交換振り飛車       |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | きｍきｍ金           |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | ポンポン桂           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | ５筋位取り           |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 玉頭位取り           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 地下鉄飛車           |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 飯島流引き角戦法     |                  |                                                |        2 |
# >> | Bioshogi::AttackInfo  | 丸山ワクチン         |                  | 新丸山ワクチン                                 |        7 |
# >> | Bioshogi::AttackInfo  | 新丸山ワクチン       | 丸山ワクチン     |                                                |        8 |
# >> | Bioshogi::AttackInfo  | ▲４六銀左急戦         |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | ▲４五歩早仕掛け       |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 鷺宮定跡             |                  |                                                |        6 |
# >> | Bioshogi::AttackInfo  | 棒銀                 |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | ▲４六銀右急戦         |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 左美濃急戦           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 右四間飛車急戦       |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | 鳥刺し               |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | 嬉野流               |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 棒金                 |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 超速▲３七銀                 |                  |                                                |        5 |
# >> | Bioshogi::AttackInfo  | 対振り持久戦         |                  |                                                |        1 |
# >> | Bioshogi::AttackInfo  | 高田流左玉           |                  |                                                |        3 |
# >> | Bioshogi::AttackInfo  | ▲７二飛亜急戦         |                  |                                                |        7 |
# >> | Bioshogi::AttackInfo  | 袖飛車               |                  |                                                |        0 |
# >> | Bioshogi::AttackInfo  | 一直線穴熊           |                  |                                                |        8 |
# >> | Bioshogi::AttackInfo  | 穴角戦法             |                  | 穴角向かい飛車                                 |        0 |
# >> | Bioshogi::AttackInfo  | 穴角向かい飛車       | 穴角戦法         |                                                |        1 |
# >> | Bioshogi::AttackInfo  | うっかり三間飛車     |                  |                                                |        4 |
# >> | Bioshogi::AttackInfo  | アヒル戦法           |                  |                                                |        7 |
# >> |---------------------+----------------------+------------------+------------------------------------------------+----------|
