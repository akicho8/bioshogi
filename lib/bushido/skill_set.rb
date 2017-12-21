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

    # 重複しているように感じる囲いなどを整理する
    def normalize_list(list)
      # 「ダイヤモンド美濃」から見た「美濃囲い」や「片美濃囲い」を消す
      list -= list.flat_map { |e| e.ancestors }
      # さらに「ダイヤモンド美濃」に含まれる「銀美濃」を消す
      # 「ダイヤモンド美濃」の直接の親ではないが、派生元と見なしてもよいものが other_parents にある
      list -= list.flat_map { |e| e.other_parents.flat_map {|e| e.self_and_ancestors } }
      list
    end

    def to_h
      TacticInfo.inject({}) { |a, e|
        a.merge(e.key => public_send("normalized_#{e.var_key}").collect(&:key))
      }
    end

    def kif_comment(location)
      TacticInfo.collect { |e|
        if v = public_send("normalized_#{e.var_key}").presence
          [location.name, e.name, "：", v.collect(&:name).join(', '), "\n"].sum("*")
        end
      }.compact.join.presence
    end
  end
end
