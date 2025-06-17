# frozen-string-literal: true

module Bioshogi
  module Analysis
    class SkillSet
      include Enumerable

      def initialize
        @value = {} # 本当は Hash.new { |h, k| h[k] = {} } としたいが、そうすると Marshal.dump できなくなる
        freeze
      end

      def value(key)
        @value[key] ||= List[]
      end

      def each(&block)
        TacticInfo.collect { |e| public_send(e.list_key) }.each(&block)
      end

      TacticInfo.each do |e|
        define_method(e.list_key) { value(e.key) }
      end

      def list_of(skill)
        value(skill.tactic_key)
      end

      def list_push(skill)
        skill = TagIndex.fetch(skill)
        list_of(skill) << skill
      end

      def has_skill?(skill)
        list_of(skill).include?(skill)
      end

      def to_h
        TacticInfo.inject({}) do |a, e|
          a.merge(e.key => value(e.key).normalize.collect(&:name))
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

      ################################################################################

      # 結果が決まってからの処理
      def rikisen_check_process
        if power_battle?
          list_push(AttackInfo["力戦"])
        end
      end

      # 力戦条件
      def power_battle?
        attack_infos.empty? && defense_infos.empty?
      end

      ################################################################################

      class List < Set
        def normalize
          self
        end

        # 重複しているように感じる囲いなどを整理したのち別名を追加した文字列リストを返す
        def normalized_names_with_alias
          normalize.flat_map { |e| [e.name, *e.alias_names] }
        end
      end
    end
  end
end
