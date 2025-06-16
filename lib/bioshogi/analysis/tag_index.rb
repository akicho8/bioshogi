module Bioshogi
  module Analysis
    module TagIndex
      extend self

      # TagIndex.lookup("金底の歩").key # => :金底の歩
      def lookup(key)
        values_hash[key.to_s.to_sym]
      end

      def fetch_if(key)
        if key
          fetch(key)
        end
      end

      def fetch(key)
        values_hash.fetch(key.to_s.to_sym)
      end

      # 曖昧検索用
      # TagIndex.fuzzy_lookup("アヒル").key # => :アヒル戦法
      def fuzzy_lookup(key)
        found = nil
        abbrev_expand(key).each do |str|
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

      # トリガーがある場合はそれだけ登録すればよくて
      # 登録がないものはすべてをトリガーキーと見なす
      def primary_soldier_hash_table
        @primary_soldier_hash_table ||= values.each_with_object({}) do |e, m|
          if e.shape_info
            e.board_parser.primary_soldiers.each do |s|
              # soldier 自体をキーにすればほどよく分散できる
              m[s] ||= []
              m[s] << e
            end
          end
        end
      end

      def piece_box_added_proc_list
        @piece_box_added_proc_list ||= values.find_all(&:if_capture_then)
      end

      def every_time_proc_list
        @every_time_proc_list ||= values.find_all(&:every_time_proc)
      end

      private

      def abbrev_expand(str)
        str = str.to_s.strip
        [
          # "アヒル戦法"
          str,
          # "アヒル" → "アヒル戦法"
          str + "戦法",
          str + "囲い",
          str + "流",
          # "都成流戦法" → "都成流"
          str.remove(/戦法\z/),
          str.remove(/囲い\z/),
          str.remove(/流\z/),
          # 特殊
          str.sub(/向かい飛車/, "向飛車"), # "向かい飛車" → "向飛車"
          str.sub(/向飛車/, "向かい飛車"), # "向飛車" → "向かい飛車"
        ]
      end
    end
  end
end
