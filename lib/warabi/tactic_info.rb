module Warabi
  class TacticInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :defense,   name: "囲い", },
      { key: :attack,    name: "戦型", },
      { key: :technique, name: "手筋", },
    ]

    def model
      @model ||= "warabi/#{key}_info".classify.constantize
    end

    def list_key
      "#{key}_infos"
    end

    class << self
      # TacticInfo.flat_lookup("金底の歩").key # => :金底の歩
      def flat_lookup(key)
        v = nil
        each do |e|
          if v = e.model.lookup(key)
            break
          end
        end
        v
      end

      def all_elements
        @all_elements ||= flat_map { |e| e.model.to_a }
      end

      # technique_matcher_info を持っている all_elements
      def piece_hash_table
        @piece_hash_table ||= all_elements.each_with_object({}) do |e, m|
          technique_matcher_info = e.technique_matcher_info
          if technique_matcher_info
            e.trigger_piece_keys.each do |trigger_piece_key|
              key = trigger_piece_key.values
              m[key] ||= []
              m[key] << e
            end
          end
        end

      end

      # トリガーがある場合はそれだけ登録すればよくて
      # 登録がないものはすべてをトリガーキーと見なす
      def soldier_hash_table
        @soldier_hash_table ||= all_elements.each_with_object({}) do |e, m|
          if e.shape_info
            e.board_parser.primary_soldiers.each do |s|
              # soldier 自体をキーにすればほどよく分散できる
              m[s] ||= []
              m[s] << e
            end
          end
        end
      end
    end
  end
end
