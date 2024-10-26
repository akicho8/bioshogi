# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :ShapeInfoRelation do
      included do
        delegate :board_parser, :location_split, :sorted_soldiers, to: :shape_info
      end

      def shape_info
        @shape_info ||= ShapeInfo.lookup(key)
      end

      # def shape_infos
      #   if shape_info
      #     shape_infos = []
      #     if respond_to?(:other_shape_keys)
      #       shape_infos = other_shape_keys.collect { |e| ShapeInfo.fetch(e) }
      #     end
      #     [shape_info, *shape_infos]
      #   end
      # end
      #
      # def primary_soldier_hash_table
      #   if shape_info
      #     shape_infos.each_with_object({}) do |e, m|
      #       e.board_parser.primary_soldiers.each_with_object({}) do |s, m|
      #         # soldier 自体をキーにすればほどよく分散できる
      #         m[s] ||= []
      #         m[s] << self
      #       end
      #     end
      #   end
      # end
    end
  end
end
