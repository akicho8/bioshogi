# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class GyokutousenDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          retv = perform_block do
            # 【却下】すでに持っている
            skip_if { player.tag_bundle.include?("玉頭戦") }

            # 【条件】互いの玉が存在する
            and_cond { king_soldiers.all? }

            # 【条件】互いの玉の列の差が1以内である (column_range を使うよりおそらく高速なので先に判定するでほとんどを除外する)
            and_cond { black_king.place.column.distance(white_king.place.column) <= 1 }

            # 【条件】互いの玉が2段目以上である
            and_cond { king_soldiers.all? { |e| e.bottom_spaces >= 1 } }

            # 【条件】動かした駒が二つの玉の行の間にある
            and_cond { row_range.cover?(soldier.place.row.value) }

            # 【条件】動かした駒が二つの玉の列の間にある
            and_cond { column_range.cover?(soldier.place.column.value) }

            # 【条件】互いの玉の行の差が間隔3である (美濃状態=間隔5, 互いに3段目相当=間隔3)
            and_cond { row_range.size <= (3 + 2) }

            # 【却下】どちらかの玉頭が安全である
            skip_if do
              king_soldiers.any? do |soldier|
                if v = soldier.relative_move_to(:up)
                  if s = board[v]
                    s.piece.key == :pawn && s.normal? && s.location == soldier.location
                  end
                end
              end
            end
          end

          if retv
            tag_add("玉頭戦")
          end
        end

        def king_soldiers
          @king_soldiers ||= container.players.collect(&:king_soldier)
        end

        def black_king
          @black_king ||= container.player_at(:black).king_soldier
        end

        def white_king
          @white_king ||= container.player_at(:white).king_soldier
        end

        # 座標は左→右の順で大きくなるので先後関係なく座標が 小さい方..大きい方 になるようにする
        def column_range
          @column_range ||= yield_self do
            a, b = king_soldiers.collect { |e| e.place.column.value }
            if a > b
              a, b = b, a
            end
            a..b
          end
        end

        # 座標が上から下になっているため w..b でよい
        def row_range
          @row_range ||= yield_self do
            b, w = king_soldiers.collect { |e| e.place.row.value }
            w..b
          end
        end
      end
    end
  end
end
