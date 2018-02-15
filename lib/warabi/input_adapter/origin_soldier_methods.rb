# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :OriginSoldierMethods do
      def origin_soldier
        if v = point_from
          player.board.fetch(v)
        end
      end
    end
  end
end
