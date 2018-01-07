require "./example_helper"

skill_set = SkillSet.new
skill_set.defense_infos << DefenseInfo["片美濃囲い"]
skill_set.defense_infos << DefenseInfo["銀美濃"]
skill_set.defense_infos << DefenseInfo["ダイヤモンド美濃"]
skill_set.defense_infos << DefenseInfo["坊主美濃"]
skill_set.defense_infos.collect(&:key)               # => [:片美濃囲い, :銀美濃, :ダイヤモンド美濃, :坊主美濃]
skill_set.defense_infos.normalize.collect(&:key)    # => [:ダイヤモンド美濃, :坊主美濃]
skill_set.defense_infos.normalize.flat_map {|e|[e.key, *e.alias_names]} # => [:ダイヤモンド美濃, :坊主美濃, "大山美濃"]
