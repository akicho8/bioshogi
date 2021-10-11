require "./setup"

skill_set = SkillSet.new
skill_set.defense_infos << DefenseInfo["片美濃囲い"]
skill_set.defense_infos << DefenseInfo["銀美濃"]
skill_set.defense_infos << DefenseInfo["ダイヤモンド美濃"]
skill_set.defense_infos << DefenseInfo["坊主美濃"]
skill_set.defense_infos << DefenseInfo["天野矢倉"]
skill_set.defense_infos.collect(&:key)              # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃, :天野矢倉]
skill_set.defense_infos.normalize.collect(&:key)    # => [:ダイヤモンド美濃, :坊主美濃, :天野矢倉]
skill_set.defense_infos.normalized_names_with_alias # => ["ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉"]
skill_set.normalized_names_with_alias # => ["ダイヤモンド美濃", "坊主美濃", "天野矢倉", "片矢倉"]
