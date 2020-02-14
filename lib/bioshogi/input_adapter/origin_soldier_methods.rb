# frozen-string-literal: true

# 角落ちで "33角(22)" とすると下の player.board.fetch(v) でエラーになる
# なので move_hand があるときは同時に origin_soldier のチェックも必要になる
#
# しかし、このチェックをやりつづけるとバリデーションが爆発する
# ここだけではく Piece.fetch などでも例外は出るかもしれない
# 他の部分でひっかかるならそれは普通に例外を出させて
# abstract_adapter.rb の perform_validations で例外を捕まえる
# この方がシンプルで良い

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
