# frozen-string-literal: true

module Bushido
  class SkillSet
    attr_accessor :attack_infos
    attr_accessor :defense_infos

    def attack_infos
      @attack_infos ||= []
    end

    def defense_infos
      @defense_infos ||= []
    end

    def normalized_attack_infos
      @normalized_attack_infos ||= normalize_list(attack_infos)
    end

    def normalized_defense_infos
      @normalized_defense_infos ||= normalize_list(defense_infos)
    end

    # ダイヤモンド美濃を持っていれば美濃囲いを消す
    def normalize_list(list)
      # ダイヤモンド美濃から見た美濃囲いや片美濃囲い
      # p [list.collect(&:key), list.flat_map { |e| e.ancestors.drop(1) }.collect(&:key)]
      list - list.flat_map { |e| e.ancestors }
    end

    def to_h
      SkillGroupInfo.inject({}) { |a, e|
        a.merge(e.key => public_send("normalized_#{e.var_key}").collect(&:key))
      }
    end

    def kif_comment(location)
      SkillGroupInfo.collect { |e|
        if v = public_send("normalized_#{e.var_key}").presence
          [location.name, e.name, "：", v.collect(&:name).join(', '), "\n"].sum("*")
        end
      }.compact.join.presence
    end
  end
end
