module Bioshogi
  module Board
    class Basic
      delegate :hash, to: :surface

      def initialize(&block)
        if block_given?
          yield self
        end
      end

      def surface
        @surface ||= {}
      end

      include UpdateMethods
      include ReaderMethods

      # FIXME: 画像用の場合はこれらを含まないクラスを使いたい
      include DetectorMethods
      prepend Analysis::ColumnSoldierCounterMethods      # カラムをキーにして列の駒数を得る
      prepend Analysis::BoardPieceCountsMethods          # 「先後と駒」をキーにして駒数を得る / 先後をキーにして駒数を得る
      prepend Analysis::SoldierPlaceMethods              # 「先後と駒」をキーにして soldier を得る
    end
  end
end
