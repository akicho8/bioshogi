# frozen-string-literal: true

module Bioshogi
  concern :ShapeInfoRelation do
    included do
      delegate :board_parser, :location_split, :sorted_soldiers, to: :shape_info
    end

    def shape_info
      ShapeInfo.lookup(key)
    end
  end
end
