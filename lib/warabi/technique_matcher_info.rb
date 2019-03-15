# frozen-string-literal: true

module Warabi
  class TechniqueMatcherInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: "金底の歩",
        verify_process: proc {
          if false
            p executor.drop_hand
            soldier = executor.hand.soldier
            p soldier.piece.key
            p soldier.bottom_spaces
            p soldier.place
            p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
          end

          # # 「打」でないとだめ
          # unless executor.drop_hand
          #   throw :skip
          # end

          soldier = executor.hand.soldier

          # 「最下段」でないとだめ
          unless soldier.bottom_spaces == 0
            throw :skip
          end

          # # 「歩」でないとだめ
          # unless soldier.piece.key == :pawn
          #   throw :skip
          # end

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
        verify_process: proc {
          if false
            p executor.move_hand
            soldier = executor.move_hand.soldier
            p soldier.piece.key
            p soldier.bottom_spaces
            p soldier.place
            p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
          end

          # # 「移動」でなければだめ
          # unless executor.move_hand
          #   throw :skip
          # end

          soldier = executor.move_hand.soldier

          # 「3段目」でないとだめ
          unless soldier.bottom_spaces == 2
            throw :skip
          end

          # 「端から3つ目」でなければだめ
          unless soldier.smaller_one_of_side_spaces == 2
            throw :skip
          end

          # # 「桂」でないとだめ
          # unless soldier.piece.key == :knight && !soldier.promoted
          #   throw :skip
          # end

          # 移動元は「端から2つ目」でなければだめ(△61から飛んだ場合を除外する)
          unless executor.move_hand.origin_soldier.smaller_one_of_side_spaces == 1
            throw :skip
          end

          # 下に2つ、壁の方に2つ
          place = soldier.place
          v = Place.lookup([place.x.value + soldier.sign_to_goto_closer_side * 2, place.y.value + soldier.location.value_sign * 2])

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
        verify_process: proc {
          soldier = executor.hand.soldier

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

      {
        key: "垂れ歩",
        verify_process: proc {
          soldier = executor.hand.soldier

          # 2, 3, 4段目でなければだめ(1段目は反則)
          v = soldier.top_spaces
          unless 1 <= v && v <= Dimension::Yplace._promotable_size
            throw :skip
          end

          # 一歩先が空
          place = soldier.place
          v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])
          if surface[v]
            throw :skip
          end
        },
      },

      {
        key: "遠見の角",
        verify_process: proc {
          # # 「打」でなければだめ
          # unless executor.drop_hand
          #   throw :skip
          # end

          soldier = executor.hand.soldier

          # # 「角」でないとだめ
          # unless soldier.piece.key == :bishop
          #   throw :skip
          # end

          # 8段目でなければだめ
          unless soldier.bottom_spaces == 1
            throw :skip
          end

          # 端でなければだめ
          unless soldier.smaller_one_of_side_spaces == 0
            throw :skip
          end
        },
      },

      {
        key: "割り打ちの銀",
        verify_process: proc {
          # # 「打」でなければだめ
          # unless executor.drop_hand
          #   throw :skip
          # end

          soldier = executor.hand.soldier

          # # 「銀」でないとだめ
          # unless soldier.piece.key == :silver
          #   throw :skip
          # end

          # 一つ下の左右に相手の金か飛がいる
          place = soldier.place
          retv = [-1, +1].all? do |x|
            v = Place.lookup([place.x.value + x, place.y.value + soldier.location.value_sign]) # 1歩後ろ
            if v = surface[v]
              if v.location != soldier.location
                v.piece.key == :rook || v.piece.key == :gold
              end
            end
          end
          unless retv
            throw :skip
          end
        },
      },

      {
        key: "桂頭の銀",
        verify_process: proc {
          soldier = executor.hand.soldier

          # 1つ上
          place = soldier.place
          v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])

          # 1つ上の位置になにかないとだめ
          unless v = surface[v]
            throw :skip
          end

          # 1つ上の駒が「相手」の「桂」でないとだめ
          unless v.piece.key == :knight && v.location != soldier.location
            throw :skip
          end
        },
      },

      {
        key: "ロケット",
        verify_process: proc {
          soldier = executor.hand.soldier

          # 1つ下
          place = soldier.place
          v = Place.lookup([place.x.value, place.y.value + soldier.location.value_sign])

          # なにかないとだめ
          unless v = surface[v]
            throw :skip
          end

          # 駒が「自分」の「香」か「飛」でないとだめ
          unless v.location == soldier.location
            throw :skip
          end
          unless (v.piece.key == :lance && !v.promoted) || v.piece.key == :rook
            throw :skip
          end
        },
      },
    ]
  end
end
