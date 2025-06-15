module Bioshogi
  module Board
    module DetectorMethods
      # 180度回転した盤面を返す
      def flip
        self.class.new.tap do |board|
          surface.values.each do |e|
            board.place_on(e.flip)
          end
        end
      end

      # X軸のみを反転した盤面を返す
      def flop
        self.class.new.tap do |board|
          surface.values.each do |e|
            board.place_on(e.flop)
          end
        end
      end
    end
  end
end
