# frozen-string-literal: true

module Bioshogi
  module Analysis
    class TagBundle
      include Enumerable

      def initialize
        @value = {} # 本当は Hash.new { |h, k| h[k] = {} } としたいが、そうすると Marshal.dump できなくなる
        freeze
      end

      def each(&block)
        TacticInfo.collect { |e| value(e) }.each(&block)
      end

      TacticInfo.each do |e|
        define_method(e.list_key) { value(e) }
      end

      def list_of(tag)
        value(tag.tactic_info)
      end

      def <<(tag)
        tag = TagIndex.fetch(tag)
        list_of(tag) << tag
      end

      def has_tag?(tag)
        tag = TagIndex.fetch(tag)
        list_of(tag).include?(tag)
      end

      def include?(...)
        has_tag?(...)
      end

      def delete_tag(tag)
        tag = TagIndex.fetch(tag)
        list_of(tag).delete(tag)
      end

      def to_h
        TacticInfo.inject({}) do |a, e|
          a.merge(e.key => value(e).normalize.collect(&:name))
        end
      end

      def all_tags
        TacticInfo.flat_map { |e| value(e).to_a }
      end

      def normalized_names_with_alias
        flat_map(&:normalized_names_with_alias)
      end

      def kif_comment(location)
        TacticInfo.collect { |e|
          if v = value(e).normalize.presence
            [location.name, e.name, "：", v.collect(&:name).join(", "), "\n"].sum("*")
          end
        }.compact.join.presence
      end

      def value(tactic_info)
        @value[TacticInfo.fetch(tactic_info).key] ||= List[]
      end

      concerning :SupportMethods do
        # 戦法と囲いのスタイル(複数)のなかからもっとも変態に近いものを得る
        def main_style_info
          (value(:attack) + value(:defense)).collect(&:style_info).max
        end

        # 力戦条件
        def attack_and_defense_is_blank?
          value(:attack).empty? && value(:defense).empty?
        end

        # 確信を持って「振り飛車」である
        def certainty_furibisha
          include?("振り飛車")
        end

        # 確信を持って「居飛車」である
        def certainty_ibisha
          include?("居飛車")
        end

        # 確信はないが振り飛車でなないのであれば居飛車か？
        def may_be_ibisha?
          !certainty_furibisha
        end

        def ibisha_or_furibisha
          certainty_furibisha ? "振り飛車" : "居飛車"
        end
      end

      ################################################################################

      private

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
