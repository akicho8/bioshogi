module Bioshogi
  class TacticInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :defense,   name: "囲い", },
      { key: :attack,    name: "戦型", },
      { key: :technique, name: "手筋", },
      { key: :note,      name: "備考", },
    ]

    def model
      @model ||= "bioshogi/#{key}_info".classify.constantize
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
            v = e.trigger_piece_key
            keys = nil
            case v[:motion]
            when :both
              keys = [
                [v[:piece_key], v[:promoted], true],   # 「打」許可
                [v[:piece_key], v[:promoted], false],  # 「移動」も許可
              ]
            when :move
              keys = [
                [v[:piece_key], v[:promoted], false],
              ]
            when :drop
              keys = [
                [v[:piece_key], v[:promoted], true],
              ]
            else
              raise "must not happen"
            end
            keys.each do |key|
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

      def piece_box_added_proc_list
        @piece_box_added_proc_list ||= all_elements.find_all do |e|
          e.respond_to?(:piece_box_added_proc) && e.piece_box_added_proc
        end
      end

      def every_time_proc_list
        @every_time_proc_list ||= all_elements.find_all do |e|
          e.respond_to?(:every_time_proc) && e.every_time_proc
        end
      end
    end
  end
end
