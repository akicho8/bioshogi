# frozen-string-literal: true

module Bioshogi
  module Explain
    class TechniqueMatcherInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "金底の歩",
          logic_desc: "打った歩が一番下の段でその上に自分の金がある",
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
            # if !executor.drop_hand
            #   throw :skip
            # end

            soldier = executor.hand.soldier

            # 「最下段」でないとだめ
            if soldier.bottom_spaces != 0
              throw :skip
            end

            # # 「歩」でないとだめ
            # if soldier.piece.key != :pawn
            #   throw :skip
            # end

            # 1つ上の位置
            place = soldier.place
            v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])

            # 1つ上の位置になにかないとだめ
            s = surface[v]
            if !s
              throw :skip
            end

            # 1つ上の駒が「自分」の「金」でないとだめ
            if !(s.piece.key == :gold && s.location == soldier.location)
              throw :skip
            end
          },
        },

        {
          key: "パンツを脱ぐ",
          logic_desc: "開戦前かつ、跳んだ桂が下から3つ目かつ、(近い方の)端から3つ目かつ、移動元の隣(端に近い方)に自分の玉がある",
          verify_process: proc {
            if false
              p executor.move_hand
              soldier = executor.move_hand.soldier
              p soldier.piece.key
              p soldier.bottom_spaces
              p soldier.place
              p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
            end

            soldier = executor.move_hand.soldier

            # 「3段目」でないとだめ
            if soldier.bottom_spaces != 2
              throw :skip
            end

            # 「端から3つ目」でなければだめ
            if soldier.smaller_one_of_side_spaces != 2
              throw :skip
            end

            # 移動元は「端から2つ目」でなければだめ(△61から飛んだ場合を除外する)
            if executor.move_hand.origin_soldier.smaller_one_of_side_spaces != 1
              throw :skip
            end

            # FIXME: origin_soldier
            # 下に2つ、壁の方に2つ
            place = soldier.place
            v = Place.lookup([place.x.value + soldier.sign_to_goto_closer_side * 2, place.y.value + soldier.location.value_sign * 2])

            # そこに何かないとだめ
            s = surface[v]
            if !s
              throw :skip
            end

            # その駒が「自分」の「玉」でないとだめ
            if !(s.piece.key == :king && s.location == soldier.location)
              throw :skip
            end
          },
        },

        {
          key: "腹銀",
          logic_desc: "銀を打ったり移動したとき左右どちらかに相手の玉がある",
          verify_process: proc {
            soldier = executor.hand.soldier

            # 左右に相手の玉がいるか？
            place = soldier.place
            retv = [-1, +1].any? do |x|
              v = Place.lookup([place.x.value + x, place.y.value])
              if s = surface[v]
                s.piece.key == :king && s.location != soldier.location
              end
            end
            if !retv
              throw :skip
            end
          },
        },

        {
          key: "垂れ歩",
          logic_desc: "打った歩の前が空で次に成れる余地がある場合",
          verify_process: proc {
            soldier = executor.hand.soldier

            # 2, 3, 4段目でなければだめ(1段目は反則)
            v = soldier.top_spaces
            if !(1 <= v && v <= Dimension::Yplace._promotable_size)
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
          logic_desc: "打った角の位置が下から2番目かつ近い方の端から1番目(つまり自分の香の上の位置)",
          verify_process: proc {
            soldier = executor.hand.soldier

            # 8段目でなければだめ
            if soldier.bottom_spaces != 1
              throw :skip
            end

            # 端でなければだめ
            if soldier.smaller_one_of_side_spaces != 0
              throw :skip
            end
          },
        },

        {
          key: "割り打ちの銀",
          logic_desc: "打った銀の後ろの左右両方に相手の飛か金がある",
          verify_process: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            retv = [-1, +1].all? do |x|
              v = Place.lookup([place.x.value + x, place.y.value + soldier.location.value_sign])
              if s = surface[v]
                if s.location != soldier.location
                  (s.piece.key == :rook && !s.promoted) || s.piece.key == :gold
                end
              end
            end
            if !retv
              throw :skip
            end
          },
        },

        {
          key: "桂頭の銀",
          logic_desc: "打った銀の上に相手の桂がある",
          verify_process: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])
            if !(s = surface[v])
              throw :skip
            end
            if !(s.piece.key == :knight && !s.promoted && s.location != soldier.location)
              throw :skip
            end
          },
        },

        {
          key: "ロケット",
          logic_desc: "打った香の下に自分の香か飛か龍がある",
          verify_process: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            v = Place.lookup([place.x.value, place.y.value + soldier.location.value_sign])
            if !(s = surface[v])
              throw :skip
            end
            if s.location != soldier.location
              throw :skip
            end
            if !((s.piece.key == :lance && !s.promoted) || s.piece.key == :rook)
              throw :skip
            end
          },
        },

        {
          key: "ふんどしの桂",
          logic_desc: "打った桂の2つ前の左右に自分より価値の高い相手の駒がある",
          verify_process: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            retv = [-1, +1].all? do |x|
              v = Place.lookup([place.x.value + x, place.y.value - soldier.location.value_sign * 2])
              if s = surface[v]
                if s.location != soldier.location
                  s.abs_weight > soldier.abs_weight
                end
              end
            end
            if !retv
              throw :skip
            end
          },
        },

        {
          key: "継ぎ桂",
          logic_desc: "打った桂の2つ後ろの左右のどちらかに自分の桂がある",
          verify_process: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            retv = [-1, +1].any? do |x|
              v = Place.lookup([place.x.value + x, place.y.value + soldier.location.value_sign * 2])
              if s = surface[v]
                s.piece.key == :knight && !s.promoted && s.location == soldier.location
              end
            end
            if !retv
              throw :skip
            end
          },
        },

        {
          key: "入玉",
          logic_desc: "玉が移動して上のスペースが3つの状態から2つの状態になった",
          verify_process: proc {
            soldier = executor.hand.soldier
            if soldier.top_spaces != Dimension::Yplace._promotable_size - 1
              throw :skip
            end

            origin_soldier = executor.hand.origin_soldier
            if origin_soldier.top_spaces != Dimension::Yplace._promotable_size
              throw :skip
            end

            # ここで相手を見て、相手も入玉していたら、次のように相入玉とする方法もあるが
            # player.skill_set.note_infos << Explain::NoteInfo["相入玉"]
            # それでなくてもここは処理が重いのでやらない
            # exporter.xcontainer_run_once の方で、最後にチェックしている
          },
        },

        {
          key: "角不成",
          logic_desc: "相手陣地に入るときと出るときの両方チェックする",
          verify_process: proc {
            if !executor.hand.origin_soldier.next_promotable?(executor.soldier.place)
              throw :skip
            end
          },
        },

        {
          key: "飛車不成",
          logic_desc: "角不成と同じ方法でよい",
          verify_process: proc {
            if !executor.hand.origin_soldier.next_promotable?(executor.soldier.place)
              throw :skip
            end
          },
        },
      ]
    end
  end
end
