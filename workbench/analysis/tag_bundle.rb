require "#{__dir__}/setup"

tag_bundle = Analysis::TagBundle.new
tag_bundle.defense_infos << Analysis::DefenseInfo["片美濃囲い"]
tag_bundle.defense_infos << Analysis::DefenseInfo["銀美濃"]
tag_bundle.defense_infos << Analysis::DefenseInfo["ダイヤモンド美濃"]
tag_bundle.defense_infos << Analysis::DefenseInfo["坊主美濃"]
tag_bundle.defense_infos << Analysis::DefenseInfo["天野矢倉"]
tag_bundle.defense_infos.collect(&:key)              # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃, :天野矢倉]
tag_bundle.defense_infos.normalize.collect(&:key)    # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃, :天野矢倉]
tag_bundle.defense_infos.normalized_names_with_alias # => ["片美濃囲い", "銀美濃", "ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉", "藤井矢倉"]
tag_bundle.normalized_names_with_alias               # => ["片美濃囲い", "銀美濃", "ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉", "藤井矢倉"]
tag_bundle.main_style_info                           # => <準変態>
tag_bundle.all_tags                                  # => [<片美濃囲い>, <銀美濃>, <ダイヤモンド美濃>, <坊主美濃>, <天野矢倉>]
