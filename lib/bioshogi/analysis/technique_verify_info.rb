# frozen-string-literal: true

# :OPTION: は考慮する必要があるもの。

module Bioshogi
  module Analysis
    class TechniqueVerifyInfo
      # UP    = V[ 0, -1]
      # RIGHT = V[ 1,  0]
      # LEFT  = V[-1,  0]
      # DOWN  = V[ 0,  1]

      LR            = [-1, +1]                           # 1ステップの左右
      LR2           = [[1, 2], [-1, -2]]                 # 1〜2ステップの左右
      # LRUD_PLUS_TWO = [[2, 0], [-2, 0], [0, 2],[ 0, -2]] # 1つ離れたところの上下左右

      ROW_IS_2  = 1 # ▲から見て2段目のこと

      Y_UP   = -1
      Y_DOWN = 1

      # SIDE_PLUS_1   = 1 # 2筋と8筋は左右から「1」つ内側にある
      # # ▲から見て2筋と8筋
      # ARRAY_2_8     = [SIDE_PLUS_1, Dimension::PlaceX.dimension.pred - SIDE_PLUS_1] # [2, 8]
      # SET_2_8       = ARRAY_2_8.to_set                                                 # #<Set: {2, 3}>
      # RANGE_2_8     = Range.new(*ARRAY_2_8)                                            # 2..8

      include ApplicationMemoryRecord
      memory_record [
        {
          key: "金底の歩",
          description: "打ち歩が一番下の段でかつ、その上に自分の金がある",
          func: proc {
            # 1. 「最下段」であること
            verify_if { soldier.bottom_spaces.zero? }

            # 2. 上に自分の金があること
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :gold && s.location == location
                end
              end
            end
          },
        },

        {
          key: "一間竜",
          description: "上下左右の1つ離れたところのどこかに相手の玉がある",
          func: proc {
            verify_if do
              V.ikkenryu_vectors.any? do |e|
                if v = soldier.move_to(e)
                  if s = surface[v]
                    s.piece.key == :king && opponent?(s)
                  end
                end
              end
            end
          },
        },

        {
          key: "こびん攻め",
          description: "玉または飛の斜めの歩を攻める",
          func: proc {
            # 1. 2〜8筋であること (端の場合は「こびん」とは言わないため)
            verify_if { place.x_is_two_to_eight? }

            # 2. 相手が歩であること
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :pawn && !s.promoted && opponent?(s)
                end
              end
            end

            # 3. 桂馬の効きの位置に「玉」または「飛車」があること
            verify_if do
              V.keima_vectors.any? do |e|
                if v = soldier.move_to(e)
                  if s = surface[v]
                    (s.piece.key == :king || (s.piece.key == :rook && !s.promoted)) && opponent?(s)
                  end
                end
              end
            end
          },
        },

        {
          key: "位の確保",
          description: "中盤戦になる前に5段目の歩を銀で支える",
          func: proc {
            # 1. 前線(6段目)にいること
            verify_if { soldier.kurai_sasae? }

            # 2. 3〜7列であること (両端2列は「位」とは言わないため)
            verify_if { place.x_is_three_to_seven? }

            # 3. 前に歩があること
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :pawn && !s.promoted && s.location == location
                end
              end
            end

            # 4. 歩の上には何もないこと
            verify_if do
              if v = soldier.move_to(:up_up)
                !surface[v]
              end
            end
          },
        },

        # FIXME
        {
          key: "パンツを脱ぐ",
          description: "開戦前かつ、跳んだ桂が下から3つ目かつ、(近い方の)端から3つ目かつ、移動元の隣(端に近い方)に自分の玉がある",
          func: proc {
            # 1. 下から3段目であること
            verify_if { soldier.bottom_spaces == 2 }

            # 2. 端から3つ目であること
            verify_if { soldier.smaller_one_of_side_spaces == 2 }

            # 移動元は「端から2つ目」でなければだめ(△61から飛んだ場合を除外する)
            verify_if { origin_soldier.smaller_one_of_side_spaces == 1 }

            # ↓↓→→の位置に自分の「玉」があること
            verify_if do
              if v = place.xy_add(soldier.sign_to_goto_closer_side * 2, location.sign_dir * 2)
                # p v
                # p origin_soldier.place
                # p origin_soldier.sign_to_goto_closer_side
                # if v = origin_soldier.place.xy_add(origin_soldier.sign_to_goto_closer_side, location.sign_dir)
                # p v
                # p v
                # p surface[v]
                if s = surface[v]
                  s.piece.key == :king && s.location == location
                end
              end
            end
          },
        },

        {
          key: "腹銀",
          description: "銀を打ったとき左右どちらかに相手の玉がある",
          func: proc {
            verify_if do
              V.left_right_vectors.any? do |e|
                if v = soldier.move_to(e)
                  if s = surface[v]
                    s.piece.key == :king && opponent?(s)
                  end
                end
              end
            end
          },
        },

        {
          key: "尻銀",
          description: "銀を打ったとき下に相手の玉がある",
          func: proc {
            verify_if do
              if v = soldier.move_to(:down)
                if s = surface[v]
                  s.piece.key == :king && opponent?(s)
                end
              end
            end
          },
        },

        {
          key: "垂れ歩",
          description: "打った歩の前が空で次に成れる余地がある場合",
          func: proc {
            # 1. 2, 3, 4 段目であること
            verify_if { soldier.tarehu_ikeru? }

            # 2. 先が空であること
            verify_if do
              if v = soldier.move_to(:up)
                !surface[v]
              end
            end
          },
        },

        # 単に「18角打」をチェックした方がいい → やめ → 自力判定する
        {
          key: "遠見の角",
          description: "打った角の位置が下から2番目かつ近い方の端から1番目(つまり自分の香の上の位置)",
          func: proc {
            soldier = executor.hand.soldier
            location = soldier.location
            place = soldier.place

            # 中盤以降であること (そうしないと序盤の77角打まで該当してしまう)
            if executor.container.outbreak_turn
            else
              throw :skip
            end

            # 自陣から打っていること
            if soldier.own_side?
            else
              throw :skip
            end

            # # 端でなければだめ
            # if soldier.smaller_one_of_side_spaces != 0
            #   throw :skip
            # end

            # 角の4方向のレイ
            vectors = soldier.piece.all_vectors(location: location) # => 
            # 敵陣に進むベクトルに絞る
            vectors = vectors.find_all { |x, y| y != location.sign_dir } # => 

            matched = vectors.any? do |x, y|      # 左上と右上を試す
              step_count = 0                   # 斜めの効きの数 (駒に衝突したらそこも含める)
              opponent_territory = nil         # 一直線に相手の陣地に入れるか？
              pos = place                      # 開始地点
              Dimension::PlaceY.dimension.times do |i|
                if pos = Place.lookup([pos.x.value + x, pos.y.value + y])
                  step_count += 1                                  # 効きの数+1
                  opponent_territory ||= pos.opp_side?(location) # 相手の陣地に入れるか？
                  surface[pos] and break                           # 相手の駒または自分の駒がある場合は終わる
                else
                  break                                            # 外に出た
                end
              end

              if false
                p "距離:#{step_count}, 入陣:#{opponent_territory}"
              end

              # 4 だとマッチしすぎるため 5 にする (5にするなら5の列ならskipにすれば最適化できるが不具合の元なのでやらない)
              step_count >= 5 && opponent_territory
            end

            unless matched
              throw :skip
            end
          },
        },

        {
          key: "割り打ちの銀",
          description: "打った銀の後ろの左右両方に相手の飛か金がある",
          func: proc {
            verify_if do
              V.wariuchi_vectors.all? do |e|
                if v = soldier.move_to(e)
                  if s = surface[v]
                    if opponent?(s)
                      (s.piece.key == :rook && !s.promoted) || s.piece.key == :gold
                    end
                  end
                end
              end
            end
          },
        },

        # FIXME
        {
          key: "たすきの銀",
          description: "打った銀の斜めに飛と金がある",
          func: proc {
            verify_if do
              [1, -1].any? do |x|
                if v = place.xy_add(-x, -location.sign_dir) # 81
                  if s = surface[v]
                    if s.piece.key == :rook && !s.promoted && opponent?(s) # 左上に飛車がある
                      if v = place.xy_add(x, location.sign_dir) # 63
                        if s = surface[v]
                          (s.piece.key == :gold || (s.piece.key == :silver && s.promoted)) && opponent?(s) # 右下に金または成銀がある
                        end
                      end
                    end
                  end
                end
              end
            end
          },
        },

        {
          key: "たすきの角",
          description: "打った角の斜めに飛と金がある",
          func: proc {
            instance_eval(&TechniqueVerifyInfo[:"たすきの銀"].func)
          },
        },

        {
          key: "桂頭の銀",
          description: "打った銀の上に相手の桂がある",
          func: proc {
            # 1. 上に相手の桂がある
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :knight && !s.promoted && opponent?(s)
                end
              end
            end

            # 2. 「22銀」や「82銀」ではないこと :OPTION:
            # - 端玉に対しての腹銀が「桂頭の銀」扱いになる場合が多いため除外している
            # - ただ本当に21や81の桂に対して「桂頭の銀」をかましている場合もなくはない
            verify_if do
              !(place.x_is_two_or_eight? && soldier.top_spaces == ROW_IS_2)
            end
          },
        },

        {
          key: "歩頭の桂",
          description: "打った桂の上に相手の歩がある",
          func: proc {
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :pawn && !s.promoted && opponent?(s)
                end
              end
            end
          },
        },

        {
          key: "銀ばさみ",
          description: "動かした歩の左右どちらかに相手の銀があり、その向こうに自分の歩がある。また歩の前に何もないこと。",
          func: proc {
            # 1. 「同歩」でないこと
            verify_if { !executor.move_hand.captured_soldier }

            # 2. 進めた歩の前が空であること
            verify_if do
              if v = soldier.move_to(:up)
                !surface[v]
              end
            end

            # 左右どちらかが成立していること
            verify_if do
              V.ginbasami_verctors.any? do |right, right_right, right_right_up|
                # 3. 右に相手の銀ある
                found = yield_self do
                  if v = soldier.move_to(right)
                    if s = surface[v]
                      s.piece.key == :silver && !s.promoted && opponent?(s)
                    end
                  end
                end
                found or next

                # 4. 右右に自分の歩がある
                found = yield_self do
                  if v = soldier.move_to(right_right)
                    if s = surface[v]
                      s.piece.key == :pawn && !s.promoted && own?(s)
                    end
                  end
                end
                found or next

                # 5. 右右上が空である
                if v = soldier.move_to(right_right_up)
                  !surface[v]
                end
              end
            end
          },
        },

        {
          key: "端玉には端歩",
          description: nil,
          func: proc {
            # 1. 端であること
            verify_if { place.x_is_left_or_right? }

            # 2. 上が相手の歩であること (▲16歩△14歩の状態で▲15歩としたということ)
            verify_if do
              if v = soldier.move_to(:up)
                if s = surface[v]
                  s.piece.key == :pawn && !s.promoted && opponent?(s)
                end
              end
            end

            # 3. 奥に相手の玉がいること (13→12→11と探す)
            verify_if do
              # この 2 は 15 - 2 = 13 の 2 で、15を基点にしているとすれば14に歩があり13から調べるため
              # Dimension::PlaceY.dimension は書かなくてもいい
              (2..Dimension::PlaceY.dimension).any? do |y|
                if v = soldier.move_to_xy(0, Y_UP * y)
                  if s = surface[v]
                    if s.piece.key == :king && opponent?(s)
                      true
                    else
                      break     # 駒があるが玉でない場合は切り上げる
                    end
                  end
                else
                  break         # 一番上まで調べたが玉はいなかった
                end
              end
            end

            # 4. 下に「自分の香飛龍」 (17→18→19と探す)
            verify_if do
              # この 2 は突いた歩の 2 つ下から香を調べるため
              (2..Dimension::PlaceY.dimension).any? do |y|
                if v = soldier.move_to_xy(0, Y_DOWN * y)
                  if s = surface[v]
                    if s.maeni_ittyokusen? && own?(s) # 「自分の香飛龍」か？
                      true
                    else
                      break     # 駒があるが「自分の香飛龍」ではなかったため切り上げる
                    end
                  end
                else
                  break         # 一番下まで調べたが「自分の香飛龍」はいなかった
                end
              end
            end
          },
        },

        {
          key: "田楽刺し",
          description: "角の頭に打つ",
          func: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            mode = :walk_to_bishop
            loop do
              place = Place.lookup([place.x.value, place.y.value - soldier.location.sign_dir])
              unless place
                throw :skip     # 盤面の外なので終わり
              end
              if s = surface[place]
                if own?(s)
                  throw :skip     # 自分と同じ駒があった場合はおわり
                end
                if mode == :walk_to_bishop
                  if s.piece.key == :bishop && !s.promoted
                    mode = :walk_to_king
                  end
                else
                  if s.piece.dengaku_target
                    break
                  end
                end
              else
                # 駒がないので次のマスに進む
              end
            end
          },
        },

        {
          key: "ふんどしの桂",
          description: "打った桂の2つ前の左右に自分より価値の高い相手の駒がある",
          func: proc {
            soldier = executor.hand.soldier
            place = soldier.place
            matched = LR.all? do |x|
              v = Place.lookup([place.x.value + x, place.y.value - soldier.location.sign_dir * 2])
              if s = surface[v]
                if opponent?(s)
                  s.abs_weight > soldier.abs_weight
                end
              end
            end
            unless matched
              throw :skip
            end
          },
        },

        {
          key: "土下座の歩",
          description: nil,
          func: proc {
            soldier = executor.hand.soldier
            place = soldier.place

            # 8,9段目であること
            if soldier.bottom_spaces < 2
            else
              throw :skip
            end

            # 一つ上が空であること
            v = Place.lookup([place.x.value, place.y.value - soldier.location.sign_dir])
            if surface[v]
              throw :skip
            end

            # 二つ上に相手の前に進める駒があること
            flag = false
            v = Place.lookup([place.x.value, place.y.value - (soldier.location.sign_dir * 2)])
            if s = surface[v]
              if opponent?(s)
                if s.promoted || s.piece.maesusumeru
                  flag = true
                end
              end
            end
            unless flag
              throw :skip
            end
          },
        },

        {
          key: "たたきの歩",
          description: "取ると取り返せるような場合もたたきの歩として判別されるのであまり正しくない",
          func: proc {
            soldier = executor.hand.soldier
            place = soldier.place

            # # 中盤以降は無効とする
            # if executor.container.turn_info.display_turn.next >= 42
            #   throw :skip
            # end

            # 打った位置が1から4段目である
            if soldier.top_spaces <= Dimension::PlaceY.promotable_depth
            else
              throw :skip
            end

            # 相手が「成駒」または「飛金銀香玉」である
            flag = false
            v = Place.lookup([place.x.value, place.y.value - soldier.location.sign_dir])
            if s = surface[v]
              if opponent?(s)
                if s.promoted || s.piece.tatakare_target
                  flag = true
                end
              end
            end
            unless flag
              throw :skip
            end

            # 打った位置の後ろに自分の(前に進めることのできる)駒があるなら無効とする (厳密な判定ではない)
            v = Place.lookup([place.x.value, place.y.value + soldier.location.sign_dir])
            if s = surface[v]
              if own?(s)
                if s.promoted || s.piece.maesusumeru
                  throw :skip
                end
              end
            end

            # 2手前に歩を前に打っているなら現在は「連打の歩」になるためスキップする
            y2 = soldier.place.y.value - soldier.location.sign_dir # 24歩のY座標(整数値)
            if hand_log = executor.container.hand_logs[-2]
              if s = hand_log&.drop_hand&.soldier
                if s.piece.key == :pawn && s.place.x == place.x && s.place.y.value == y2 && own?(s)
                  throw :skip
                end
              end
            end
          },
        },

        {
          key: "継ぎ歩",
          description: "",
          func: proc {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            soldier = executor.hand.soldier
            x = soldier.place.x
            y = soldier.place.y
            y2 = y.value - soldier.location.sign_dir # 24歩のY座標(整数値)

            # 1手前: △24同歩 取らされる
            flag = false
            if hand_log = executor.container.hand_logs[-1]
              if s = hand_log&.move_hand&.soldier
                flag = (s.place.x == x && s.place.y.value == y2 && s.piece.key == :pawn && !s.promoted && opponent?(s))
              end
            end
            unless flag
              throw :skip
            end

            # 2手前: ▲24歩(25) 突き
            flag = false
            if hand_log = executor.container.hand_logs[-2]
              if s = hand_log&.move_hand&.soldier # 最初を突き捨てとするため hand ではなく move_hand にすること
                flag = (s.place.x == x && s.place.y.value == y2 && s.piece.key == :pawn && !s.promoted && own?(s))
              end
            end
            unless flag
              throw :skip
            end
          },
        },

        {
          key: "連打の歩",
          description: "",
          func: proc {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            soldier = executor.hand.soldier
            x = soldier.place.x
            y = soldier.place.y
            y2 = y.value - soldier.location.sign_dir # 24歩のY座標(整数値)

            # 1手前: △24同何か 取らされる
            flag = false
            if hand_log = executor.container.hand_logs[-1]
              if s = hand_log&.move_hand&.soldier
                flag = (s.place.x == x && s.place.y.value == y2 && opponent?(s))
              end
            end
            unless flag
              throw :skip
            end

            # 2手前: ▲24歩打
            flag = false
            if hand_log = executor.container.hand_logs[-2]
              if s = hand_log&.drop_hand&.soldier
                if s.piece.key == :pawn && s.place.x == x && s.place.y.value == y2 && own?(s)
                  flag = true
                end
              end
            end
            unless flag
              throw :skip
            end
          },
        },

        {
          key: "継ぎ桂",
          description: "継ぐのは前なので打った桂の2つ後ろの左右のどちらかに自分の桂がある",
          func: proc {
            verify_if do
              V.tsugikei_vectors.any? do |e|
                if v = soldier.move_to(e)
                  if s = surface[v]
                    s.piece.key == :knight && !s.promoted && own?(s)
                  end
                end
              end
            end
          },
        },

        {
          key: "入玉",
          description: "玉が4段目から3段目に移動した",
          func: proc {
            verify_if { soldier.sandanme?        }
            verify_if { origin_soldier.yondanme? }
          },
        },

        {
          key: "角不成",
          description: "相手陣地に入るときと出るときの両方チェックする",
          func: proc {
            verify_if { origin_soldier.tsugini_nareru_on?(place) }
          },
        },

        {
          key: "飛車不成",
          description: "角不成と同じ方法でよい",
          func: proc {
            verify_if { origin_soldier.tsugini_nareru_on?(place) }
          },
        },
      ]
    end
  end
end
