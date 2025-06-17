module Bioshogi
  module Analysis
    module TagIndex
      extend self

      # TagIndex.lookup("金底の歩").key # => :金底の歩
      def lookup(key)
        if TagBase === key
          return key
        end
        values_hash[key.to_s.to_sym]
      end

      def fetch_if(key)
        if key
          fetch(key)
        end
      end

      def fetch(key)
        lookup(key) or raise ArgumentError, "TagIndex.fetch(#{key.inspect})"
      end

      # 曖昧検索用
      # TagIndex.fuzzy_lookup("アヒル").key # => :アヒル戦法
      def fuzzy_lookup(key)
        found = nil
        AbbrevExpander.expand(key).each do |str|
          if found = lookup(str)
            break
          end
        end
        found
      end

      def values
        @values ||= TacticInfo.flat_map { |e| e.model.values }
      end

      def values_hash
        @values_hash ||= values.inject({}) { |a, e| a.merge(e.key => e) }
      end

      ################################################################################

      # 特定の駒を指定の場所に動かしたときに発動するタイプたち
      def shape_type_values
        @shape_type_values ||= values.find_all(&:shape_info)
      end

      # 駒を取ったタイミングで発動するタイプたち
      def capture_type_values
        @capture_type_values ||= values.find_all(&:if_capture_then)
      end

      # 毎回呼ばれるタイプたち
      def every_type_values
        @every_type_values ||= values.find_all(&:if_true_then)
      end

      # モーションで発動するタイプたち
      def motion_type_values
        @motion_type_values ||= values.find_all(&:motion_detector)
      end

      ################################################################################

      # トリガーがある場合はそれだけ登録すればよくて
      # 登録がないものはすべてをトリガーキーと見なす
      def shape_trigger_table
        @shape_trigger_table ||= shape_type_values.each_with_object({}) do |e, m|
          e.shape_info.board_parser.primary_soldiers.each do |s|
            m[s] ||= []
            m[s] << e
          end
        end
      end
    end
  end
end
