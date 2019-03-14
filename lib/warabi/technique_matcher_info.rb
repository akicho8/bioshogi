# frozen-string-literal: true

module Warabi
  class TechniqueMatcherInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: "金底の歩",
        trigger_piece_keys: [:pawn],
        verify_process: proc {
          if false
            p executor.drop_hand
            soldier = executor.drop_hand.soldier
            p soldier.piece.key
            p soldier.advance_level
            p soldier.place
            p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
          end

          # 「打」でないとだめ
          unless executor.drop_hand
            throw :skip
          end

          soldier = executor.drop_hand.soldier

          # 「最下段」でないとだめ
          unless soldier.advance_level == 0
            throw :skip
          end

          # 「歩」でないとだめ
          unless soldier.piece.key == :pawn
            throw :skip
          end

          # 1つ上の位置
          place = soldier.place
          v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])

          # 1つ上の位置になにかないとだめ
          unless v = surface[v]
            throw :skip
          end

          # 1つ上の駒が「自分」の「金」でないとだめ
          unless v.piece.key == :gold && v.location == soldier.location
            throw :skip
          end
        },
      },

      {
        key: "パンツを脱ぐ",
        trigger_piece_keys: [:knight],
        verify_process: proc {
          if false
            p executor.move_hand
            soldier = executor.move_hand.soldier
            p soldier.piece.key
            p soldier.advance_level
            p soldier.place
            p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
          end

          # 「移動」でなければだめ
          unless executor.move_hand
            throw :skip
          end

          soldier = executor.move_hand.soldier

          # 「3段目」でないとだめ
          unless soldier.advance_level == 2
            throw :skip
          end

          # 「端から3つ目」でなければだめ
          unless soldier.smaller_one_of_distance_to_wall == 2
            throw :skip
          end

          # 「桂」でないとだめ
          unless soldier.piece.key == :knight && !soldier.promoted
            throw :skip
          end

          # 移動元は「端から2つ目」でなければだめ(△61から飛んだ場合を除外する)
          unless executor.move_hand.origin_soldier.smaller_one_of_distance_to_wall == 1
            throw :skip
          end

          # 下に2つ、壁の方に2つ
          place = soldier.place
          v = Place.lookup([place.x.value + soldier.distance_to_wall_sign * 2, place.y.value + soldier.location.value_sign * 2])

          # そこに何かないとだめ
          unless v = surface[v]
            throw :skip
          end

          # その駒が「自分」の「玉」でないとだめ
          unless v.piece.key == :king && v.location == soldier.location
            throw :skip
          end
        },
      },

      {
        key: "腹銀",
        trigger_piece_keys: [:silver],
        verify_process: proc {
          soldier = executor.hand.soldier

          # 「銀」でないとだめ
          unless soldier.piece.key == :silver && !soldier.promoted
            throw :skip
          end

          # 左右に相手の玉がいるか？
          place = soldier.place
          retv = [-1, +1].any? do |x|
            v = Place.lookup([place.x.value + x, place.y.value])
            if v = surface[v]
              v.piece.key == :king && v.location != soldier.location
            end
          end
          unless retv
            throw :skip
          end
        },
      },
    ]
  end
end
