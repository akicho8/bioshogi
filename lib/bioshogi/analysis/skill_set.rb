# frozen-string-literal: true

module Bioshogi
  module Analysis
    class SkillSet
      attr_accessor :attack_infos
      attr_accessor :defense_infos
      attr_accessor :technique_infos
      attr_accessor :note_infos

      include Enumerable

      def each(&block)
        [
          defense_infos,
          attack_infos,
          technique_infos,
          note_infos,
        ].each(&block)
      end

      # 力戦条件
      def power_battle?
        attack_infos.empty? && defense_infos.empty?
      end

      # 結果が決まってからの処理
      def rikisen_check_process
        if power_battle?
          list_push(AttackInfo["力戦"])
        end
      end

      def attack_infos
        @attack_infos ||= List.new
      end

      def defense_infos
        @defense_infos ||= List.new
      end

      def technique_infos
        @technique_infos ||= List.new
      end

      def note_infos
        @note_infos ||= List.new
      end

      def list_of(e)
        public_send(e.tactic_info.list_key)
      end

      def list_push(e)
        raise "must not happen" unless e
        list_of(e) << e
      end

      def list_push2(e)
        list_push(TagIndex.fetch(e))
      end

      def has_skill?(e)
        list_of(e).include?(e)
      end

      def to_h
        TacticInfo.inject({}) do |a, e|
          a.merge(e.key => public_send(e.list_key).normalize.collect(&:name))
        end
      end

      def to_all_flat_array
        flat_map(&:normalize)
      end

      def normalized_names_with_alias
        flat_map(&:normalized_names_with_alias)
      end

      def kif_comment(location)
        TacticInfo.collect { |e|
          if v = public_send(e.list_key).normalize.presence
            [location.name, e.name, "：", v.collect(&:name).join(", "), "\n"].sum("*")
          end
        }.compact.join.presence
      end

      # 戦法と囲いのスタイル(複数)のなかからもっとも変態に近いものを得る
      def main_style_info
        (attack_infos + defense_infos).collect(&:style_info).max
      end

      class List < Set
        # 重複しているように感じる囲いなどを整理する
        # たとえば "3→4→3戦法" は普通に判定すると最初に「四間飛車」になってしまうが人間からするとあきらかに違う
        # したがって経由した四間飛車を消さないといけない
        def normalize
          list = to_a
          # # 「ダイヤモンド美濃」から見た「美濃囲い」や「片美濃囲い」を消す
          # list -= list.flat_map { |e| e.ancestors }
          # # さらに「ダイヤモンド美濃」に含まれる「銀美濃」を消す
          # # 「ダイヤモンド美濃」の直接の親ではないが、派生元と見なしてもよいものが related_ancestors にある
          # list -= list.flat_map { |e| e.related_ancestors.flat_map(&:self_and_ancestors) }

          list -= list.flat_map(&:delete_infos)

          list
        end

        # # 不要な先祖を削除する
        # def unwant_rejected_ancestors
        #   to_a - to_a.flat_map { |e| e.related_ancestors.flat_map(&:self_and_ancestors) }
        # end

        # 重複しているように感じる囲いなどを整理したのち別名を追加した文字列リストを返す
        def normalized_names_with_alias
          normalize.flat_map { |e| [e.name, *e.alias_names] }
        end
      end
    end
  end
end
