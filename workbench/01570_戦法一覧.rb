require "#{__dir__}/setup"

rows = Analysis::TacticInfo.flat_map do |tactic_info|
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
# >> | Bioshogi::Analysis::AttackInfo    | 花村流名古屋戦法         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 清野流岐阜戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | GAVA角                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ▲5五龍中飛車           | 原始中飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | ノーガード戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 矢倉▲3七銀戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 脇システム               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ウソ矢倉                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 矢倉棒銀                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 森下システム             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 同型矢倉                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 雀刺し                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 米長流急戦矢倉           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | カニカニ銀               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | カニカニ金               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 中原流急戦矢倉           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 阿久津流急戦矢倉         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 藤森流急戦矢倉           | 米長流急戦矢倉     |
# >> | Bioshogi::Analysis::AttackInfo    | 屋敷流二枚銀             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 屋敷流二枚銀棒銀型       |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 矢倉中飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 矢倉流中飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 原始棒銀                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 英春流かまいたち戦法     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 高田流左玉               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 英春流カメレオン         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | パックマン戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 山崎流パックマン         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新米長玉                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 稲庭戦法                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 四手角                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 都成流△3一金           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 角換わり                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 一手損角換わり           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 角換わり腰掛け銀         | 角換わり           |
# >> | Bioshogi::Analysis::AttackInfo    | 角換わり棒銀             | 角換わり           |
# >> | Bioshogi::Analysis::AttackInfo    | 角換わり早繰り銀         | 角換わり           |
# >> | Bioshogi::Analysis::AttackInfo    | 角換わり新型             | 角換わり           |
# >> | Bioshogi::Analysis::AttackInfo    | 筋違い角                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 相筋違い角               | 筋違い角           |
# >> | Bioshogi::Analysis::AttackInfo    | 木村定跡                 | 角換わり腰掛け銀   |
# >> | Bioshogi::Analysis::AttackInfo    | 相掛かり                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 相掛かり棒銀             | 相掛かり           |
# >> | Bioshogi::Analysis::AttackInfo    | 塚田スペシャル           | 相掛かり           |
# >> | Bioshogi::Analysis::AttackInfo    | 中原流相掛かり           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 中原飛車                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 腰掛け銀                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 鎖鎌銀                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 中座飛車           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | UFO銀                    |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 横歩取り                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △3三角型空中戦法       |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △3三桂戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △2三歩戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △4五角戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 相横歩取り               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 先手中飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 中飛車ミレニアム         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 飛騨の中飛車合掌造り     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ツノ銀中飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 英ちゃん流中飛車         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 原始中飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 中飛車左穴熊             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ヒラメ戦法                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 風車                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新風車                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 加藤流袖飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ▲5七金戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 超急戦                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 遠山流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 四間飛車                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 四間飛車ミレニアム       | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | ゴキゲン中飛車           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 5筋位取り中飛車          |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 角道オープン四間飛車     | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 角交換振り飛車           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | はく式四間飛車           | 角交換振り飛車     |
# >> | Bioshogi::Analysis::AttackInfo    | 耀龍四間飛車             | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 藤井システム             | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 室岡システム             | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 立石流四間飛車           | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | レグスペ                 | 角交換振り飛車     |
# >> | Bioshogi::Analysis::AttackInfo    | 三間飛車                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 三間飛車ミレニアム       | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | △3三飛戦法             | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 石田流                   | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 早石田                   | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | ムリヤリ早石田           | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 升田式石田流             | 早石田             |
# >> | Bioshogi::Analysis::AttackInfo    | 鬼殺し                   | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 2手目△3二飛戦法        | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | コーヤン流三間飛車                 | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 真部流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 初手▲7八飛戦法         | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 楠本式石田流             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新石田流                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新鬼殺し                 | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 九間飛車                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 九間飛車左穴熊           | 九間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 森安流袖飛車穴熊         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 3→4→3戦法              | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 戸辺流4→3戦法           | 3→4→3戦法        |
# >> | Bioshogi::Analysis::AttackInfo    | 向かい飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ダイレクト向かい飛車     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | モノレール向かい飛車     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | メリケン向かい飛車       | 向かい飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 阪田流向かい飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | オザワシステム           | 向かい飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 鬼殺し向かい飛車         | 向かい飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 菜々河流△4四角         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 菜々河流向かい飛車       | 菜々河流△4四角   |
# >> | Bioshogi::Analysis::AttackInfo    | 天彦流▲6六角           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 天彦流向かい飛車         | 天彦流▲6六角     |
# >> | Bioshogi::Analysis::AttackInfo    | 陽動振り飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 角頭歩戦法               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 玉頭銀                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | つくつくぼうし戦法       |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ひねり飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 耀龍ひねり飛車           | ひねり飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | やばボーズ流             | 一手損角換わり     |
# >> | Bioshogi::Analysis::AttackInfo    | 幻想四間飛車             | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | タランチュラ戦法         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 間宮久夢流               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ポンポン桂               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新ポンポン桂             | 角換わり           |
# >> | Bioshogi::Analysis::AttackInfo    | ショーダンオリジナル     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ショーダンシステム       | 向かい飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 村田システム             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新村田システム           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 玉頭位取り               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 6筋位取り               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 5筋位取り               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 銀雲雀                   | 5筋位取り         |
# >> | Bioshogi::Analysis::AttackInfo    | 地下鉄飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 飯島流引き角戦法         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 飯島流相掛かり引き角 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 丸山ワクチン             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新丸山ワクチン           | 丸山ワクチン       |
# >> | Bioshogi::Analysis::AttackInfo    | ▲4六銀右急戦           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ▲4六銀左急戦           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | ▲4五歩早仕掛け         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | へなちょこ急戦           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | エルモ急戦               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 鷺宮定跡                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 棒銀                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 速攻棒銀                 | 棒銀               |
# >> | Bioshogi::Analysis::AttackInfo    | 暴銀                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 左美濃急戦               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 右四間飛車               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 右四間飛車急戦           | 右四間飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 右四間飛車左美濃         | 右四間飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 右四間飛車超急戦         | 右四間飛車         |
# >> | Bioshogi::Analysis::AttackInfo    | 鳥刺し                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 嬉野流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 新嬉野流                 | 嬉野流             |
# >> | Bioshogi::Analysis::AttackInfo    | メイドシステム           | 初手▲7八銀戦法     |
# >> | Bioshogi::Analysis::AttackInfo    | 棒金                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 棒玉                     |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 超速▲3七銀             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 対振り持久戦             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △7二飛亜急戦           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 袖飛車                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 一直線穴熊               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 穴角戦法                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 穴角向かい飛車           | 穴角戦法           |
# >> | Bioshogi::Analysis::AttackInfo    | 下町流三間飛車           | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 神吉流三間飛車           | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 鈴木流早石田             | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 久保流早石田             | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 菅井流三間飛車           | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | うっかり三間飛車         | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | アヒル戦法               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 裏アヒル戦法             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 対矢倉左美濃急戦           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 青野流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 勇気流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 竹部スペシャル           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 極限早繰り銀             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | △3三金型早繰り銀           | 角換わり早繰り銀   |
# >> | Bioshogi::Analysis::AttackInfo    | 三間飛車藤井システム     | 三間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | トマホーク               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 羽生式袖飛車             |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 初手▲7八銀戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 初手▲3六歩戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 2手目△7四歩戦法          |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 4手目△3三角戦法        |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 魔界四間飛車             | 四間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | 目くらまし戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 端棒銀                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | リッチブリッジ                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | カメレオン戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | xaby角戦法               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 金沢流                   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | Uターン飛車              |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 阪田流2手目△9四歩       |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 一間飛車                 |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 一間飛車右穴熊             | 一間飛車           |
# >> | Bioshogi::Analysis::AttackInfo    | ネコ式タテ歩取り         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 桐山流タテ歩棒銀         |                    |
# >> | Bioshogi::Analysis::AttackInfo    | きんとうん戦法           |                    |
# >> | Bioshogi::Analysis::AttackInfo    | たこ金戦法   |                    |
# >> | Bioshogi::Analysis::AttackInfo    | きｍきｍ金               |                    |
# >> | Bioshogi::Analysis::AttackInfo    | 力戦                     |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 居玉                     |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | いちご囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | カニ囲い                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | カタ囲い                 | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | カブト囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀矢倉                   | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 金矢倉                   | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 総矢倉                   | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 菱矢倉                   | 総矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 富士見矢倉               | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀立ち矢倉               | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 高矢倉                   | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 四角矢倉                 | 銀矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 角矢倉                   | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 豆腐矢倉                 | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 隅矢倉                   | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 流れ矢倉                 | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 金門矢倉                 | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | へこみ矢倉               | 金門矢倉           |
# >> | Bioshogi::Analysis::DefenseInfo   | 一文字矢倉               | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | カギ囲い                 | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | オールド雁木             | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | ツノ銀雁木               | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 新型雁木                 | ツノ銀雁木         |
# >> | Bioshogi::Analysis::DefenseInfo   | 菊水矢倉                 | カニ囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 流線矢倉                 | 菊水矢倉           |
# >> | Bioshogi::Analysis::DefenseInfo   | 悪形矢倉                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 矢倉早囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 天野矢倉                 | 矢倉早囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 土居矢倉                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | ムリヤリ矢倉             |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | カニ缶囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | オリジナル雁木           |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 舟囲い                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 舟囲いDX                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 天守閣囲い               | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 左美濃                   | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 角道不突き左美濃         | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 居飛車金美濃             | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 升田美濃                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 天守閣美濃               | 左美濃             |
# >> | Bioshogi::Analysis::DefenseInfo   | 四枚美濃                 | 天守閣美濃         |
# >> | Bioshogi::Analysis::DefenseInfo   | 居飛車銀冠               | 左美濃             |
# >> | Bioshogi::Analysis::DefenseInfo   | 端玉銀冠                 | 天守閣美濃         |
# >> | Bioshogi::Analysis::DefenseInfo   | かんぴょう囲い           | 居飛車銀冠         |
# >> | Bioshogi::Analysis::DefenseInfo   | 四枚銀冠                 | 居飛車銀冠         |
# >> | Bioshogi::Analysis::DefenseInfo   | 串カツ囲い               | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 居飛車穴熊               | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 松尾流穴熊               | 居飛車穴熊         |
# >> | Bioshogi::Analysis::DefenseInfo   | 神吉流穴熊               | 左美濃             |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀冠穴熊                 | 居飛車銀冠         |
# >> | Bioshogi::Analysis::DefenseInfo   | 居飛穴音無しの構え       | 銀冠穴熊           |
# >> | Bioshogi::Analysis::DefenseInfo   | ビッグ4                  | 居飛穴音無しの構え |
# >> | Bioshogi::Analysis::DefenseInfo   | 矢倉穴熊                 | 金矢倉             |
# >> | Bioshogi::Analysis::DefenseInfo   | 文鎮囲い                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 箱入り娘                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 金盾囲い                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 大盾囲い                 | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | ミレニアム囲い           | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | セメント囲い             | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | チョコレート囲い         | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | ボナンザ囲い             | 舟囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | エルモ囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 左山囲い                 | エルモ囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 無責任矢倉               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | あずまや囲い             |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 四段端玉                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 空中楼閣                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 中原囲い                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 桐山流中原囲い           |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 中住まい                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | アヒル囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 裏アヒル囲い             |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 無敵囲い                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 右玉                     |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 矢倉右玉                 | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | 糸谷流右玉               | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | 羽生流右玉               | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | 角換わり右玉             | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | 雁木右玉                 | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | ツノ銀型右玉             | 右玉               |
# >> | Bioshogi::Analysis::DefenseInfo   | 三段右玉                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 早囲い                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車エルモ           | 早囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | ずれ美濃                 | 早囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 大隅囲い                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 連盟美濃                 | 大隅囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 片美濃囲い               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 美濃囲い                 | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | ちょんまげ美濃           |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 高美濃囲い               | 美濃囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 片銀冠                   | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀冠                     | 片銀冠             |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀美濃                   | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 金美濃                   | 早囲い             |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車四枚美濃         | 高美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | ダイヤモンド美濃         | 美濃囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 木村美濃                 | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 大山美濃                 | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 美濃熊囲い               | 片美濃囲い         |
# >> | Bioshogi::Analysis::DefenseInfo   | 裾固め                   | 木村美濃           |
# >> | Bioshogi::Analysis::DefenseInfo   | 右矢倉                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車ミレニアム       |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車端玉銀冠         |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車串カツ囲い       |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車天守閣美濃       |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 紙穴熊                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車穴熊             |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車銀冠穴熊         | 振り飛車穴熊       |
# >> | Bioshogi::Analysis::DefenseInfo   | 振り飛車ビッグ4          | 振り飛車銀冠穴熊   |
# >> | Bioshogi::Analysis::DefenseInfo   | 金無双                   | 大隅囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 離れ金無双               | 大隅囲い           |
# >> | Bioshogi::Analysis::DefenseInfo   | 坊主美濃                 | ちょんまげ美濃     |
# >> | Bioshogi::Analysis::DefenseInfo   | カブト美濃               |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 銀多伝                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 金多伝                   |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | 雲隠れ玉                 |                    |
# >> | Bioshogi::Analysis::DefenseInfo   | モノレール囲い           |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 金底の歩                 |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | パンティを脱ぐ             |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 腹銀                     |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 垂れ歩                   |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 割り打ちの銀             |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | たすきの銀               |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | たすきの角               |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 桂頭の銀                 |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 田楽刺し                 |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | ふんどしの桂             |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 継ぎ桂                   |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 銀冠の小部屋             |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 幽霊角                   |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 遠見の角                 |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 2段ロケット              |                    |
# >> | Bioshogi::Analysis::TechniqueInfo | 3段ロケット              | 2段ロケット        |
# >> | Bioshogi::Analysis::TechniqueInfo | 4段ロケット              | 3段ロケット        |
# >> | Bioshogi::Analysis::TechniqueInfo | 5段ロケット              | 4段ロケット        |
# >> | Bioshogi::Analysis::TechniqueInfo | 6段ロケット              | 5段ロケット        |
# >> | Bioshogi::Analysis::NoteInfo      | 角交換型                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 手得角交換型             | 角交換型           |
# >> | Bioshogi::Analysis::NoteInfo      | 手損角交換型             | 角交換型           |
# >> | Bioshogi::Analysis::NoteInfo      | 2手目△6二銀戦法              |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 居飛車                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 振り飛車                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 相居飛車                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 相振り飛車               |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 対居飛車                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 対振り飛車               |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 対抗形                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 急戦                     |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 持久戦                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 短手数                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 長手数                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 角不成                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 飛車不成                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 入玉                     |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 相入玉                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 相居玉                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 大駒全ブッチ             |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 大駒コンプリート         |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 屍の舞                 |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 駒柱                     |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 穴熊の姿焼き             |                    |
# >> | Bioshogi::Analysis::NoteInfo      | 都詰め                   |                    |
# >> | Bioshogi::Analysis::NoteInfo      | ロケット                 |                    |
# >> |----------------------------------+--------------------------+--------------------|
