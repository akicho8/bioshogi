# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    concern :OriginSoldierMethods do
      def origin_soldier
        @origin_soldier ||= -> {
          if v = place_from
            player.board.fetch(v)
          end
        }.call
      end
    end
  end
end
