module Bushido
  class TacticInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :defense, name: "囲い"},
      {key: :attack,  name: "戦型"},
    ]

    def model
      "bushido/#{key}_info".classify.constantize
    end

    def var_key
      "#{key}_infos"
    end

    class << self
      def all_elements
        @all_elements ||= flat_map { |e| e.model.to_a }
      end

      def trigger_soldier_points_hash
        @trigger_soldier_points_hash ||= -> {
          all_elements.each_with_object({}) do |e, m|
            e.board_parser.trigger_soldiers.each do |s|
              point = s[:point]
              m[point] ||= []
              m[point] << e
            end
          end
        }.call
      end

      # # トリガーなしグループ
      # def trigger_soldier_points_hash2
      #   @trigger_soldier_points_hash2 ||= -> {
      #     all_elements.each_with_object({}) do |e, m|
      #       v = e.board_parser.trigger_soldiers
      #       if v.present?
      #       else
      #         point = s[:point]
      #         m[point] ||= []
      #         m[point] << e
      #       end
      #     end
      #   }.call
      # end

      def soldier_points_hash
        @soldier_points_hash ||= -> {
          all_elements.each_with_object({}) do |e, m|
            e.board_parser.soldiers.each do |s|
              point = s[:point]
              m[point] ||= []
              m[point] << e
            end
          end
        }.call
      end

      def all_soldier_points_hash
        @all_soldier_points_hash ||= -> {
          all_elements.each_with_object({}) do |e, m|
            (e.board_parser.soldiers + e.board_parser.trigger_soldiers).each do |s|
              point = s[:point]
              m[point] ||= []
              m[point] << e
            end
          end
        }.call
      end
    end
  end
end
