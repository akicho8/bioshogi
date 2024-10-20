require "./setup"

rows = Explain::TacticInfo.flat_map do |tactic_info|
  tactic_info.model.collect do |e|
    {
      "モデル"         => e.class.name,
      "名前"           => e.name,
      "親"             => e.parent ? e.parent.key : nil,
      # "子供"           => e.children.collect(&:key).join(" "),
      # "指定駒数"       => e.sorted_soldiers.count,
      # "配置"           => e.board_parser.sorted_soldiers.collect(&:name).join(" "),
      # "空升指定"       => e.board_parser.other_objects.find_all{|e|e[:something] == "○"}.collect{|e|e[:place].name}.join(" "),
    }
  end
end
tp rows
# >> |----------------------------------+--------------------------+--------------------|
# >> | モデル                           | 名前                     | 親                 |
# >> |----------------------------------+--------------------------+--------------------|
# >> | Bioshogi::Explain::AttackInfo    | 花村流名古屋戦法         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 清野流岐阜戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | GAVA角                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | ▲5五龍中飛車           | 原始中飛車         |
# >> | Bioshogi::Explain::AttackInfo    | ノーガード戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 矢倉▲3七銀戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 脇システム               |                    |
# >> | Bioshogi::Explain::AttackInfo    | ウソ矢倉                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 矢倉棒銀                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 森下システム             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 同型矢倉                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 雀刺し                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 米長流急戦矢倉           |                    |
# >> | Bioshogi::Explain::AttackInfo    | カニカニ銀               |                    |
# >> | Bioshogi::Explain::AttackInfo    | カニカニ金               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 中原流急戦矢倉           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 阿久津流急戦矢倉         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 藤森流急戦矢倉           | 米長流急戦矢倉     |
# >> | Bioshogi::Explain::AttackInfo    | 屋敷流二枚銀             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 屋敷流二枚銀棒銀型       |                    |
# >> | Bioshogi::Explain::AttackInfo    | 矢倉中飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 矢倉流中飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 原始棒銀                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 英春流かまいたち戦法     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 高田流左玉               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 英春流カメレオン         |                    |
# >> | Bioshogi::Explain::AttackInfo    | パックマン戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 山崎流パックマン         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新米長玉                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 稲庭戦法                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 四手角                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 都成流△3一金           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 角換わり                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 一手損角換わり           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 角換わり腰掛け銀         | 角換わり           |
# >> | Bioshogi::Explain::AttackInfo    | 角換わり棒銀             | 角換わり           |
# >> | Bioshogi::Explain::AttackInfo    | 角換わり早繰り銀         | 角換わり           |
# >> | Bioshogi::Explain::AttackInfo    | 角換わり新型             | 角換わり           |
# >> | Bioshogi::Explain::AttackInfo    | 筋違い角                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 相筋違い角               | 筋違い角           |
# >> | Bioshogi::Explain::AttackInfo    | 木村定跡                 | 角換わり腰掛け銀   |
# >> | Bioshogi::Explain::AttackInfo    | 相掛かり                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 相掛かり棒銀             | 相掛かり           |
# >> | Bioshogi::Explain::AttackInfo    | 塚田スペシャル           | 相掛かり           |
# >> | Bioshogi::Explain::AttackInfo    | 中原流相掛かり           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 中原飛車                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 腰掛け銀                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 鎖鎌銀                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 中座飛車           |                    |
# >> | Bioshogi::Explain::AttackInfo    | UFO銀                    |                    |
# >> | Bioshogi::Explain::AttackInfo    | 横歩取り                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | △3三角型空中戦法       |                    |
# >> | Bioshogi::Explain::AttackInfo    | △3三桂戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | △2三歩戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | △4五角戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 相横歩取り               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 先手中飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 中飛車ミレニアム         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 飛騨の中飛車合掌造り     |                    |
# >> | Bioshogi::Explain::AttackInfo    | ツノ銀中飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 英ちゃん流中飛車         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 原始中飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 中飛車左穴熊             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 平目                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 風車                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新風車                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 加藤流袖飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | ▲5七金戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 超急戦                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 遠山流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 四間飛車                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 四間飛車ミレニアム       | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | ゴキゲン中飛車           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 5筋位取り中飛車          |                    |
# >> | Bioshogi::Explain::AttackInfo    | 角道オープン四間飛車     | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 角交換振り飛車           |                    |
# >> | Bioshogi::Explain::AttackInfo    | はく式四間飛車           | 角交換振り飛車     |
# >> | Bioshogi::Explain::AttackInfo    | 耀龍四間飛車             | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 藤井システム             | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 室岡システム             | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 立石流四間飛車           | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | レグスペ                 | 角交換振り飛車     |
# >> | Bioshogi::Explain::AttackInfo    | 三間飛車                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 三間飛車ミレニアム       | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | △3三飛戦法             | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 石田流                   | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 早石田                   | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | ムリヤリ早石田           | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 升田式石田流             | 早石田             |
# >> | Bioshogi::Explain::AttackInfo    | 鬼殺し                   | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 2手目△3ニ飛戦法        | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 中田功XP                 | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 真部流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 初手▲7八飛戦法         | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 楠本式石田流             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新石田流                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新鬼殺し                 | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 九間飛車                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 九間飛車左穴熊           | 九間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 森安流袖飛車穴熊         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 3→4→3戦法              | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 戸部流4→3戦法           | 3→4→3戦法        |
# >> | Bioshogi::Explain::AttackInfo    | 向かい飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | ダイレクト向かい飛車     |                    |
# >> | Bioshogi::Explain::AttackInfo    | モノレール向かい飛車     |                    |
# >> | Bioshogi::Explain::AttackInfo    | メリケン向かい飛車       | 向かい飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 阪田流向飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | オザワシステム           | 向かい飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 鬼殺し向かい飛車         | 向かい飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 菜々河流△4四角         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 菜々河流向かい飛車       | 菜々河流△4四角   |
# >> | Bioshogi::Explain::AttackInfo    | 天彦流▲6六角           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 天彦流向かい飛車         | 天彦流▲6六角     |
# >> | Bioshogi::Explain::AttackInfo    | 陽動振り飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 角頭歩戦法               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 玉頭銀                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | つくつくぼうし戦法       |                    |
# >> | Bioshogi::Explain::AttackInfo    | ひねり飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 耀龍ひねり飛車           | ひねり飛車         |
# >> | Bioshogi::Explain::AttackInfo    | やばボーズ流             | 一手損角換わり     |
# >> | Bioshogi::Explain::AttackInfo    | 幻想四間飛車             | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | タランチュラ戦法         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 間宮久夢流               |                    |
# >> | Bioshogi::Explain::AttackInfo    | ポンポン桂               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新ポンポン桂             | 角換わり           |
# >> | Bioshogi::Explain::AttackInfo    | ショーダンオリジナル     |                    |
# >> | Bioshogi::Explain::AttackInfo    | ショーダンシステム       | 向かい飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 村田システム             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新村田システム           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 玉頭位取り               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 6筋位取り               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 5筋位取り               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 銀雲雀                   | 5筋位取り         |
# >> | Bioshogi::Explain::AttackInfo    | 地下鉄飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 飯島流引き角戦法         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 飯島流相掛かり引き角戦法 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 丸山ワクチン             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新丸山ワクチン           | 丸山ワクチン       |
# >> | Bioshogi::Explain::AttackInfo    | ▲4六銀右急戦           |                    |
# >> | Bioshogi::Explain::AttackInfo    | ▲4六銀左急戦           |                    |
# >> | Bioshogi::Explain::AttackInfo    | ▲4五歩早仕掛け         |                    |
# >> | Bioshogi::Explain::AttackInfo    | へなちょこ急戦           |                    |
# >> | Bioshogi::Explain::AttackInfo    | エルモ急戦               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 鷺宮定跡                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 棒銀                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 対矢倉急戦棒銀                 | 棒銀               |
# >> | Bioshogi::Explain::AttackInfo    | 暴銀                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 左美濃急戦               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 右四間飛車               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 右四間飛車急戦           | 右四間飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 右四間飛車左美濃         | 右四間飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 右四間飛車超急戦         | 右四間飛車         |
# >> | Bioshogi::Explain::AttackInfo    | 鳥刺し                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 嬉野流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 新嬉野流                 | 嬉野流             |
# >> | Bioshogi::Explain::AttackInfo    | メイドシステム           | 初手7八銀戦法     |
# >> | Bioshogi::Explain::AttackInfo    | 棒金                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 棒玉                     |                    |
# >> | Bioshogi::Explain::AttackInfo    | 超速▲3七銀             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 対振り持久戦             |                    |
# >> | Bioshogi::Explain::AttackInfo    | △7二飛亜急戦           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 袖飛車                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 一直線穴熊               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 穴角戦法                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 穴角向かい飛車           | 穴角戦法           |
# >> | Bioshogi::Explain::AttackInfo    | 下町流三間飛車           | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 神吉流三間飛車           | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 鈴木流早石田             | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 久保流早石田             | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 菅井流三間飛車           | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | うっかり三間飛車         | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | アヒル戦法               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 裏アヒル戦法             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 矢倉左美濃急戦           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 青野流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 勇気流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 竹部スペシャル           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 極限早繰り銀             |                    |
# >> | Bioshogi::Explain::AttackInfo    | △3三金型早繰り銀           | 角換わり早繰り銀   |
# >> | Bioshogi::Explain::AttackInfo    | 三間飛車藤井システム     | 三間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | トマホーク               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 羽生式袖飛車             |                    |
# >> | Bioshogi::Explain::AttackInfo    | 初手7八銀戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 初手3六歩戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 2手目△7四歩戦法          |                    |
# >> | Bioshogi::Explain::AttackInfo    | 4手目△3三角戦法        |                    |
# >> | Bioshogi::Explain::AttackInfo    | 魔界四間飛車             | 四間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | 目くらまし戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 端棒銀                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | 金銀橋                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | カメレオン戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | xaby角戦法               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 金沢流                   |                    |
# >> | Bioshogi::Explain::AttackInfo    | Uターン飛車              |                    |
# >> | Bioshogi::Explain::AttackInfo    | 阪田流2手目△9四歩       |                    |
# >> | Bioshogi::Explain::AttackInfo    | 一間飛車                 |                    |
# >> | Bioshogi::Explain::AttackInfo    | 一間飛車穴熊             | 一間飛車           |
# >> | Bioshogi::Explain::AttackInfo    | ネコ式タテ歩取り         |                    |
# >> | Bioshogi::Explain::AttackInfo    | 桐山流タテ歩棒銀         |                    |
# >> | Bioshogi::Explain::AttackInfo    | きんとうん戦法           |                    |
# >> | Bioshogi::Explain::AttackInfo    | 対ひねり飛車たこ金戦法   |                    |
# >> | Bioshogi::Explain::AttackInfo    | きｍきｍ金               |                    |
# >> | Bioshogi::Explain::AttackInfo    | 力戦                     |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 居玉                     |                    |
# >> | Bioshogi::Explain::DefenseInfo   | いちご囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | カニ囲い                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | カタ囲い                 | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | カブト囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 銀矢倉                   | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 金矢倉                   | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 総矢倉                   | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 菱矢倉                   | 総矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 富士見矢倉               | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 銀立ち矢倉               | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 高矢倉                   | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 四角矢倉                 | 銀矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 角矢倉                   | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 豆腐矢倉                 | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 隅矢倉                   | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 流れ矢倉                 | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 金門矢倉                 | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | へこみ矢倉               | 金門矢倉           |
# >> | Bioshogi::Explain::DefenseInfo   | 一文字矢倉               | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | カギ囲い                 | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | オールド雁木             | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | ツノ銀雁木               | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 新型雁木                 | ツノ銀雁木         |
# >> | Bioshogi::Explain::DefenseInfo   | 菊水矢倉                 | カニ囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 流線矢倉                 | 菊水矢倉           |
# >> | Bioshogi::Explain::DefenseInfo   | 悪形矢倉                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 矢倉早囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 天野矢倉                 | 矢倉早囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 土居矢倉                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | ムリヤリ矢倉             |                    |
# >> | Bioshogi::Explain::DefenseInfo   | カニ缶囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | オリジナル雁木           |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 舟囲い                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 舟囲いDX                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 天守閣囲い               | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 左美濃                   | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 角道不突き左美濃         | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 居飛車金美濃             | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 升田美濃                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 天守閣美濃               | 左美濃             |
# >> | Bioshogi::Explain::DefenseInfo   | 四枚美濃                 | 天守閣美濃         |
# >> | Bioshogi::Explain::DefenseInfo   | 居飛車銀冠               | 左美濃             |
# >> | Bioshogi::Explain::DefenseInfo   | 端玉銀冠                 | 天守閣美濃         |
# >> | Bioshogi::Explain::DefenseInfo   | かんぴょう囲い           | 居飛車銀冠         |
# >> | Bioshogi::Explain::DefenseInfo   | 四枚銀冠                 | 居飛車銀冠         |
# >> | Bioshogi::Explain::DefenseInfo   | 串カツ囲い               | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 居飛車穴熊               | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 松尾流穴熊               | 居飛車穴熊         |
# >> | Bioshogi::Explain::DefenseInfo   | 神吉流穴熊               | 左美濃             |
# >> | Bioshogi::Explain::DefenseInfo   | 銀冠穴熊                 | 居飛車銀冠         |
# >> | Bioshogi::Explain::DefenseInfo   | 居飛穴音無しの構え       | 銀冠穴熊           |
# >> | Bioshogi::Explain::DefenseInfo   | ビッグ4                  | 居飛穴音無しの構え |
# >> | Bioshogi::Explain::DefenseInfo   | 矢倉穴熊                 | 金矢倉             |
# >> | Bioshogi::Explain::DefenseInfo   | 文鎮囲い                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 箱入り娘                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 金盾囲い                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 大盾囲い                 | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | ミレニアム囲い           | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | セメント囲い             | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | チョコレート囲い         | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | ボナンザ囲い             | 舟囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | エルモ囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 左山囲い                 | エルモ囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 無責任矢倉               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | あずまや囲い             |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 四段端玉                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 空中楼閣                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 中原囲い                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 桐山流中原囲い           |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 中住まい                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | アヒル囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 裏アヒル囲い             |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 無敵囲い                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 右玉                     |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 矢倉右玉                 | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | 糸谷流右玉               | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | 羽生流右玉               | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | 角換わり右玉             | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | 雁木右玉                 | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | ツノ銀型右玉             | 右玉               |
# >> | Bioshogi::Explain::DefenseInfo   | 三段右玉                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 早囲い                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車エルモ           | 早囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | ずれ美濃                 | 早囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 大隅囲い                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 連盟美濃                 | 大隅囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 片美濃囲い               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 美濃囲い                 | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | ちょんまげ美濃           |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 高美濃囲い               | 美濃囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 片銀冠                   | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 銀冠                     | 片銀冠             |
# >> | Bioshogi::Explain::DefenseInfo   | 銀美濃                   | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 金美濃                   | 早囲い             |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車四枚美濃         | 高美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | ダイヤモンド美濃         | 美濃囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 木村美濃                 | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 大山美濃                 | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 美濃熊囲い               | 片美濃囲い         |
# >> | Bioshogi::Explain::DefenseInfo   | 裾固め                   | 木村美濃           |
# >> | Bioshogi::Explain::DefenseInfo   | 右矢倉                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車ミレニアム       |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車端玉銀冠         |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車串カツ囲い       |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車天守閣美濃       |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 紙穴熊                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車穴熊             |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車銀冠穴熊         | 振り飛車穴熊       |
# >> | Bioshogi::Explain::DefenseInfo   | 振り飛車ビッグ4          | 振り飛車銀冠穴熊   |
# >> | Bioshogi::Explain::DefenseInfo   | 金無双                   | 大隅囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 離れ金無双               | 大隅囲い           |
# >> | Bioshogi::Explain::DefenseInfo   | 坊主美濃                 | ちょんまげ美濃     |
# >> | Bioshogi::Explain::DefenseInfo   | カブト美濃               |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 銀多伝                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 金多伝                   |                    |
# >> | Bioshogi::Explain::DefenseInfo   | 雲隠れ玉                 |                    |
# >> | Bioshogi::Explain::DefenseInfo   | モノレール囲い           |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 金底の歩                 |                    |
# >> | Bioshogi::Explain::TechniqueInfo | パンツを脱ぐ             |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 腹銀                     |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 垂れ歩                   |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 割り打ちの銀             |                    |
# >> | Bioshogi::Explain::TechniqueInfo | たすきの銀               |                    |
# >> | Bioshogi::Explain::TechniqueInfo | たすきの角               |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 桂頭の銀                 |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 田楽刺し                 |                    |
# >> | Bioshogi::Explain::TechniqueInfo | ふんどしの桂             |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 継ぎ桂                   |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 銀冠の小部屋             |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 幽霊角                   |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 遠見の角                 |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 2段ロケット              |                    |
# >> | Bioshogi::Explain::TechniqueInfo | 3段ロケット              | 2段ロケット        |
# >> | Bioshogi::Explain::TechniqueInfo | 4段ロケット              | 3段ロケット        |
# >> | Bioshogi::Explain::TechniqueInfo | 5段ロケット              | 4段ロケット        |
# >> | Bioshogi::Explain::TechniqueInfo | 6段ロケット              | 5段ロケット        |
# >> | Bioshogi::Explain::NoteInfo      | 角交換型                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 手得角交換型             | 角交換型           |
# >> | Bioshogi::Explain::NoteInfo      | 手損角交換型             | 角交換型           |
# >> | Bioshogi::Explain::NoteInfo      | 2手目△6二銀              |                    |
# >> | Bioshogi::Explain::NoteInfo      | 居飛車                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 振り飛車                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 相居飛車                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 相振り飛車               |                    |
# >> | Bioshogi::Explain::NoteInfo      | 対居飛車                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 対振り飛車               |                    |
# >> | Bioshogi::Explain::NoteInfo      | 対抗形                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 急戦                     |                    |
# >> | Bioshogi::Explain::NoteInfo      | 持久戦                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 短手数                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 長手数                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 角不成                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 飛車不成                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 入玉                     |                    |
# >> | Bioshogi::Explain::NoteInfo      | 相入玉                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 相居玉                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | 大駒全ブッチ             |                    |
# >> | Bioshogi::Explain::NoteInfo      | 大駒コンプリート         |                    |
# >> | Bioshogi::Explain::NoteInfo      | 背水の陣                 |                    |
# >> | Bioshogi::Explain::NoteInfo      | 駒柱                     |                    |
# >> | Bioshogi::Explain::NoteInfo      | 穴熊の姿焼き             |                    |
# >> | Bioshogi::Explain::NoteInfo      | 都詰め                   |                    |
# >> | Bioshogi::Explain::NoteInfo      | ロケット                 |                    |
# >> |----------------------------------+--------------------------+--------------------|
