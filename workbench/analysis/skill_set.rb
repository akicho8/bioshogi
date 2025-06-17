require "#{__dir__}/setup"

skill_set = Analysis::SkillSet.new
skill_set.defense_infos << Analysis::DefenseInfo["片美濃囲い"]
skill_set.defense_infos << Analysis::DefenseInfo["銀美濃"]
skill_set.defense_infos << Analysis::DefenseInfo["ダイヤモンド美濃"]
skill_set.defense_infos << Analysis::DefenseInfo["坊主美濃"]
skill_set.defense_infos << Analysis::DefenseInfo["天野矢倉"]
skill_set.defense_infos.collect(&:key)              # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃, :天野矢倉]
skill_set.defense_infos.normalize.collect(&:key)    # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃, :天野矢倉]
skill_set.defense_infos.normalized_names_with_alias # => ["片美濃囲い", "銀美濃", "ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉", "藤井矢倉"]
skill_set.normalized_names_with_alias               # => ["片美濃囲い", "銀美濃", "ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉", "藤井矢倉"]
skill_set.main_style_info                           # => <準変態>
