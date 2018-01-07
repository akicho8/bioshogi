# frozen-string-literal: true

module Bushido
  class SkillSet
    attr_accessor :attack_infos
    attr_accessor :defense_infos

    include Enumerable

    def each(&block)
      [defense_infos, attack_infos].each(&block)
    end

    def attack_infos
      @attack_infos ||= List.new
    end

    def defense_infos
      @defense_infos ||= List.new
    end

    def to_h
      TacticInfo.inject({}) do |a, e|
        a.merge(e.key => public_send(e.list_key).normalize.collect(&:key))
      end
    end

    def kif_comment(location)
      TacticInfo.collect { |e|
        if v = public_send(e.list_key).normalize.presence
          [location.name, e.name, "：", v.collect(&:name).join(', '), "\n"].sum("*")
        end
      }.compact.join.presence
    end

    class List < Array
      # 重複しているように感じる囲いなどを整理する
      def normalize
        list = to_a
        # 「ダイヤモンド美濃」から見た「美濃囲い」や「片美濃囲い」を消す
        list -= list.flat_map { |e| e.ancestors }
        # さらに「ダイヤモンド美濃」に含まれる「銀美濃」を消す
        # 「ダイヤモンド美濃」の直接の親ではないが、派生元と見なしてもよいものが other_parents にある
        list -= list.flat_map { |e| e.other_parents.flat_map(&:self_and_ancestors) }
        list
      end
    end
  end
end
