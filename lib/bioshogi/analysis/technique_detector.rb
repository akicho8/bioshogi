# frozen-string-literal: true

# :OPTIONAL: は考慮する必要があるもの。

module Bioshogi
  module Analysis
    class TechniqueDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "蓋歩",
          description: "飛車を帰らせない",
          func: -> {
            # 【条件1】打った歩の下には、1手前に相手の飛車が移動してきていて、その飛車の前方1マスは空いている
            verify_if do
              if hand_log = executor.container.hand_logs[-1]
                if s = hand_log.move_hand&.soldier
                  if s.piece.key == :rook && s.normal? && opponent?(s)
                    if s.place == soldier.relative_move_to(:down)
                      if v = s.relative_move_to(:up)
                        board.cell_empty?(v)
                      end
                    end
                  end
                end
              end
            end

            # 【条件2】その歩は桂か銀に支えられている
            verify_if do
              func = -> (vectors, piece_key) {
                V.public_send(vectors).any? do |e|
                  if v = soldier.relative_move_to(e)
                    if s = board[v]
                      s.piece.key == piece_key && s.normal? && own?(s)
                    end
                  end
                end
              }
              func[:tsugikei_vectors, :knight] || func[:wariuchi_vectors, :silver]
            end
          },
        },
        {
          key: "金底の歩",
          description: "打ち歩が一番下の段でかつ、その上に自分の金がある",
          func: -> {
            # 【条件1】「最下段」である
            verify_if { soldier.bottom_spaces.zero? }

            # 【条件2】上に自分の金がある
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :gold && own?(s)
                end
              end
            end
          },
        },
        {
          key: "一間竜",
          description: "上下左右の1つ離れたところのどこかに相手の玉がある",
          func: -> {
            verify_if do
              V.ikkenryu_vectors.any? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
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
          func: -> {
            # 【条件1】2〜8筋である (端の場合は「こびん」とは言わないため)
            verify_if { soldier.column_is_second_to_eighth? }

            # 【条件2】相手が歩である
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件3】桂馬の効きの位置に「玉」または「飛車」がある
            verify_if do
              V.keima_vectors.any? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    (s.piece.key == :king || (s.piece.key == :rook && s.normal?)) && opponent?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "位の確保",
          description: "中盤戦になる前に5段目の歩を銀で支える",
          func: -> {
            # 【条件1】前線(6段目)にいること
            verify_if { soldier.kurai_sasae? }

            # 【条件2】3〜7列である (両端2列は「位」とは言わないため)
            verify_if { soldier.column_is_three_to_seven? }

            # 【条件3】前に歩がある
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && own?(s)
                end
              end
            end

            # 【条件4】歩の上に何もないこと (歩の上に何か駒があった場合は無効) :OPTIONAL:
            skip_if do
              if v = soldier.relative_move_to(:up_up)
                board[v]
              end
            end
          },
        },
        {
          key: "パンツを脱ぐ",
          description: "開戦前かつ、跳んだ桂が下から3つ目かつ、(近い方の)端から3つ目かつ、移動元の隣(端に近い方)に自分の玉がある",
          func: -> {
            # 【条件1】下から3段目である
            verify_if { soldier.bottom_spaces == 2 }

            # 【条件2】端から3つ目である
            verify_if { soldier.column_spaces_min == 2 }

            # 【条件3】動元は「端から2つ目」である (▲41から飛んだ場合を除外する)
            verify_if { origin_soldier.column_spaces_min == 1 }

            # 【条件4】移動元の端側に「玉」がある
            verify_if do
              if v = origin_soldier.relative_move_to(soldier.left_or_right_to_closer_side)
                if s = board[v]
                  s.piece.key == :king && own?(s)
                end
              end
            end
          },
        },

        ################################################################################ 銀

        {
          key: "腹銀",
          description: "銀を打ったか移動させたとき左右どちらかに相手の玉がある",
          func: -> {
            verify_if do
              V.left_right_vectors.any? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    s.piece.key == :king && opponent?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "尻銀",
          description: "銀を打ったか移動させたとき下に相手の玉がある",
          func: -> {
            verify_if do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  s.piece.key == :king && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "肩銀",
          description: "銀を打ったか移動させたとき左斜め前か右斜め前に玉がある",
          func: -> {
            verify_if do
              V.bishop_naname_mae_vectors.any? do |up_left|
                if v = soldier.relative_move_to(up_left)
                  if s = board[v]
                    s.piece.key == :king && opponent?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "裾銀",
          description: "銀を打ったか移動させたとき左斜め後か右斜め後に玉がある",
          func: -> {
            verify_if do
              V.wariuchi_vectors.any? do |down_left|
                if v = soldier.relative_move_to(down_left)
                  if s = board[v]
                    s.piece.key == :king && opponent?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "頭銀",
          description: "銀を打ったか移動させたとき前に相手の玉がある",
          func: -> {
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :king && opponent?(s)
                end
              end
            end
          },
        },

        ################################################################################ 金

        {
          key: "腹金",
          description: "金を打ったか移動させたとき左右どちらかに相手の玉がある",
          func: -> { instance_exec(&TechniqueDetector[:"腹銀"].func) },
        },
        {
          key: "尻金",
          description: "金を打ったか移動させたとき下に相手の玉がある",
          func: -> { instance_exec(&TechniqueDetector[:"尻銀"].func) },
        },
        {
          key: "肩金",
          description: "金を打ったか移動させたとき左斜め前か右斜め前に玉がある",
          func: -> { instance_exec(&TechniqueDetector[:"肩銀"].func) },
        },
        {
          key: "裾金",
          description: "金を打ったか移動させたとき左斜め後か右斜め後に玉がある",
          func: -> { instance_exec(&TechniqueDetector[:"裾銀"].func) },
        },
        {
          key: "頭金",
          description: "金を打ったか移動させたとき前に相手の玉がある",
          func: -> { instance_exec(&TechniqueDetector[:"頭銀"].func) },
        },

        ################################################################################

        {
          key: "垂れ歩",
          description: "打った歩の前が空で次に成れる余地がある場合",
          func: -> {
            # 【条件1】2, 3, 4 段目である
            verify_if { soldier.tarefu_desuka? }

            # 【条件2】先が空である
            verify_if do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end
          },
        },

        # 単に「18角打」をチェックした方がいい → やめ → 自力判定する
        {
          key: "遠見の角",
          description: "打った角の位置が下から2番目かつ近い方の端から1番目(つまり自分の香の上の位置)",
          func: -> {
            # 【条件1】中盤以降である (そうしないと序盤の77角打まで該当してしまう) :OPTIONAL:
            verify_if { executor.container.outbreak_turn }

            # 【条件2】自陣から打っていること
            verify_if { soldier.own_side? }

            # 【条件3】端から打っていること
            if false
              verify_if { soldier.column_is_edge? }
            end

            # 【条件4】相手の陣地に直通しているかつ長さが 5 以上である
            verify_if do
              threshold = 5                                       # 成立するステップ数。4 だとマッチしすぎるため 5 にする
              V.bishop_naname_mae_vectors.any? do |up_left|       # 左上と右上を試す
                matched = false
                step = 0                                          # 斜めの効きの数 (駒に衝突したらそこも含める)
                Dimension::Row.dimension_size.times do |i|
                  if v = soldier.relative_move_to(up_left, magnification: 1 + i)
                    step += 1                                     # 効きの数+1
                    if step >= threshold && v.opp_side?(location) # 相手の陣地に入れるか？
                      matched = true
                      break
                    end
                    board[v] and break                          # 相手の駒または自分の駒がある場合は終わる
                  else
                    break                                         # 外に出た
                  end
                end
                matched
              end
            end
          },
        },
        {
          key: "割り打ちの銀",
          description: "打った銀の後ろの左右両方に相手の飛か金がある",
          func: -> {
            verify_if do
              V.wariuchi_vectors.all? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    if opponent?(s)
                      (s.piece.key == :rook && s.normal?) || s.piece.key == :gold
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "たすきの銀",
          description: "打った銀の斜め前に飛があり対極に金がある",
          func: -> {
            verify_if do
              V.tasuki_vectors.any? do |up_left, down_right|
                if v = soldier.relative_move_to(up_left)
                  if s = board[v]
                    if s.piece.key == :rook && s.normal? && opponent?(s) # 左上に飛車がある
                      if v = soldier.relative_move_to(down_right)
                        if s = board[v]
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
          description: "打った角の斜め前に飛があり対極に金がある",
          func: -> { instance_exec(&TechniqueDetector[:"たすきの銀"].func) },
        },
        {
          key: "壁金",
          description: "飛車や角の位置に玉よりも先に金が移動した",
          func: -> {
            # 【条件1】端から2つ目である
            verify_if { soldier.column_spaces_min == 1 }

            # 【条件2】下から2段目である
            verify_if { soldier.bottom_spaces == 1 }

            # 【条件3】下に桂がある
            verify_if do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  s.piece.key == :knight && own?(s)
                end
              end
            end

            # 【条件4】上に歩がある
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && own?(s)
                end
              end
            end

            # 【条件5】移動元は端から3つ目である
            verify_if { origin_soldier.column_spaces_min == 2 }

            # 【条件6】玉との横軸の距離は3以内である (最長3 = 居玉) 銀と同じ方向に玉がいるというだけで穴熊状態の可能性もある
            verify_if { soldier.place.column.distance(player.king_place.column) <= 3 }

            # 【条件7】玉は中心から2以内にいる = 銀より内側にいる (居玉 = 0, 早囲い = 2, 美濃囲い = 3, 穴熊 = 4)
            verify_if { player.king_place.column.distance_from_center <= 3 }

            # 【条件8】玉は自分の陣地にいる
            verify_if { player.king_place.own_side?(location) }
          },
        },
        {
          key: "壁銀",
          description: "飛車や角の位置に玉よりも先に銀が移動した",
          func: -> { instance_exec(&TechniqueDetector[:"壁金"].func) },
        },
        {
          key: "桂頭の銀",
          description: "打った銀の上に相手の桂がある",
          func: -> {
            # 【条件1】上に相手の桂がある
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :knight && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件2】「22銀」や「82銀」ではないこと :OPTIONAL:
            # - 端玉に対しての腹銀が「桂頭の銀」扱いになる場合が多いため除外している
            # - ただ本当に21や81の桂に対して「桂頭の銀」をかましている場合もなくはない
            skip_if do
              soldier.column_is_second_or_eighth? && soldier.top_spaces == 1
            end
          },
        },
        {
          key: "歩頭の桂",
          description: "打ったまたは移動した桂の上に相手の歩がある",
          func: -> {
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "金頭の桂",
          description: "打ったまたは移動した桂の上に相手の金がある",
          func: -> {
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :gold && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "銀ばさみ",
          description: "動かした歩の左右どちらかに相手の銀があり、その向こうに自分の歩がある。また歩の前に何もないこと。",
          func: -> {
            # 【条件1】「同歩」でないこと
            skip_if do
              if move_hand = executor.move_hand
                move_hand.captured_soldier
              end
            end

            # 【条件2】進めた歩の前が空である
            verify_if do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end

            # 左右どちらかが成立していること
            verify_if do
              V.ginbasami_verctors.any? do |right, right_right, right_right_up|
                # 【条件3】右に相手の銀ある
                yield_self {
                  if v = soldier.relative_move_to(right)
                    if s = board[v]
                      s.piece.key == :silver && s.normal? && opponent?(s)
                    end
                  end
                } or next

                # 【条件4】右右に自分の歩がある
                yield_self {
                  if v = soldier.relative_move_to(right_right)
                    if s = board[v]
                      s.piece.key == :pawn && s.normal? && own?(s)
                    end
                  end
                } or next

                # 【条件5】右右上が空である
                if v = soldier.relative_move_to(right_right_up)
                  board.cell_empty?(v)
                end
              end
            end
          },
        },
        {
          key: "端玉には端歩",
          description: nil,
          func: -> {
            # 【条件1】端である
            verify_if { soldier.column_is_edge? }

            # 【条件2】上が相手の歩である (▲16歩△14歩の状態で▲15歩としたということ)
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件3】奥に相手の玉がいること (13→12→11と探す)
            verify_if do
              # この 2 は 15 - 2 = 13 の 2 で、15を基点にしているとすれば14に歩があり13から調べるため
              # Dimension::Row.dimension_size は書かなくてもいい
              (2..).any? do |y|
                if v = soldier.relative_move_to(:up, magnification: y)
                  if s = board[v]
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

            # 【条件4】下に「自分の香飛龍」 (17→18→19と探す)
            verify_if do
              # この 2 は突いた歩の 2 つ下から香を調べるため
              (2..).any? do |y|
                if v = soldier.relative_move_to(:down, magnification: y)
                  if s = board[v]
                    if s.boar_mode? && own?(s) # 「自分の香飛龍」か？
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
          description: "角の頭に打ってその奥に玉などの大駒がある",
          func: -> {
            verify_if do
              mode = :walk_to_bishop
              (1..).each do |y|
                if v = soldier.relative_move_to(:up, magnification: y)
                  if s = board[v]
                    if opponent?(s)
                      case mode
                      when :walk_to_bishop         # 角を探す
                        if s.piece.key == :bishop && s.normal?
                          mode = :walk_to_dengaku_target
                        end
                      when :walk_to_dengaku_target # 大駒を探す
                        if s.piece.dengaku_target
                          mode = :dengaku_matched
                          break
                        end
                      else
                        raise "must not happen"
                      end
                    else
                      break # 自分の駒が間にある場合は田楽指しではない
                    end
                  else
                    # 駒がない場合はさらに奥に進む
                  end
                else
                  break         # 盤の外に出た場合は終わる
                end
              end
              mode == :dengaku_matched
            end
          },
        },
        {
          # https://yokohamayanke.com/1078/ によると金底の香の状態でも「下段の香」として紹介されている
          # いろんな条件を考えたが結局「下段」のみのチェックとする
          key: "下段の香",
          description: "打った香が一番下",
          func: -> {
            # 【条件1】「最下段」である
            verify_if { soldier.bottom_spaces.zero? }
          },
        },
        {
          key: "ふんどしの桂",
          description: "打った桂の2つ前の左右に自分より価値の高い相手の駒がある",
          func: -> {
            verify_if do
              V.keima_vectors.all? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    if opponent?(s)
                      s.abs_weight > soldier.abs_weight
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "控えの桂",
          description: "打った桂の利きにある相手の駒を集め、それが1つ以上かつすべて歩である",
          func: -> {
            # 【条件1】打った位置が6段目以降である
            verify_if { soldier.top_spaces >= Dimension::Row.promotable_depth + 2 }

            #  打った桂の利きの2箇所にある相手の駒を取得する
            soldiers = V.keima_vectors.collect { |e|
              if v = soldier.relative_move_to(e)
                if s = board[v]
                  if opponent?(s)
                    s
                  end
                end
              end
            }.compact

            # 【条件2】 相手の駒は1つ以上ある
            verify_if { !soldiers.empty? }

            # 【条件3】 相手の駒は「歩」である
            verify_if do
              soldiers.all? { |e| e.piece.key == :pawn }
            end
          },
        },
        {
          key: "土下座の歩",
          description: nil,
          func: -> {
            # 【条件1】8,9段目である
            verify_if { soldier.bottom_spaces < 2 }

            # 【条件2】一つ上が空である
            verify_if do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end

            # 【条件3】二つ上に相手の前に進める駒がある (成銀や馬があっても土下座の対象とする)
            verify_if do
              if v = soldier.relative_move_to(:up_up)
                if s = board[v]
                  if opponent?(s)
                    s.piece.maesusumeru || s.promoted
                  end
                end
              end
            end
          },
        },
        {
          key: "たたきの歩",
          description: "取ると取り返せるような場合もたたきの歩として判別されるのであまり正しくない",
          func: -> {
            # 【条件1】打った位置が1から4段目である
            verify_if { soldier.top_spaces.between?(1, Dimension::Row.promotable_depth) }

            # 【条件2】相手が「成駒」または「飛金銀香玉」である
            verify_if do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  if opponent?(s)
                    s.promoted || s.piece.tatakare_target
                  end
                end
              end
            end

            # 【条件3】打った歩に結びついている利きがないこと
            # とするのが本当は正しいのだけど大変なので
            # 「打った位置の後ろに自分の(前に進めることのできる)駒がないこと」だけを判定している
            skip_if do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  if own?(s)
                    s.promoted || s.piece.maesusumeru
                  end
                end
              end
            end

            # 【条件4】連打の歩ではないこと :OPTIONAL:
            skip_if do
              if hand_log = executor.container.hand_logs[-2] # 前回の自分の手
                if drop_hand = hand_log.drop_hand            # 打った手
                  if s = drop_hand.soldier                   # 駒
                    Assertion.assert { own?(s) }
                    s.piece.key == :pawn && s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end
          },
        },
        {
          key: "継ぎ歩",
          description: "条件が成立しない方を先に判定した方が早めに打ち切れるので2手目1手目の順で見る",
          func: -> {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            # 2手前: ▲24歩(25) 突き
            verify_if do
              if hand_log = executor.container.hand_logs[-2]
                if s = hand_log.move_hand&.soldier # 最初を突き捨てとするため hand ではなく move_hand にしている
                  if s.piece.key == :pawn && s.normal? && own?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end

            # 1手前: △24同歩 取らされる
            verify_if do
              if hand_log = executor.container.hand_logs[-1]
                if s = hand_log.move_hand&.soldier
                  if s.piece.key == :pawn && s.normal? && opponent?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end
          },
        },
        {
          key: "連打の歩",
          description: "",
          func: -> {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            # 2手前: ▲24歩打
            verify_if do
              if hand_log = executor.container.hand_logs[-2]
                if s = hand_log.drop_hand&.soldier
                  if s.piece.key == :pawn && own?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end

            # 1手前: △24同何か 取らされる
            verify_if do
              if hand_log = executor.container.hand_logs[-1]
                if s = hand_log.move_hand&.soldier
                  if opponent?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end
          },
        },
        {
          key: "継ぎ桂",
          description: "継ぐのは前なので打った桂の2つ後ろの左右のどちらかに自分の桂がある",
          func: -> {
            verify_if do
              V.tsugikei_vectors.any? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    s.piece.key == :knight && s.normal? && own?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "跳ね違いの桂",
          description: "移動元から見て移動してない方に相手が1手前に移動した桂があるか？",
          func: -> {
            verify_if do
              # △33桂(21)▲13桂成(25)で考える
              # 跳ね違いは相手の桂を捌けなくする目的でもあるため「成っていない桂」のチェックとする
              V.keima_vectors.any? do |e|
                if v = origin_soldier.relative_move_to(e)                  # 25から33と13を見る
                  if s = board[v]                                          # そこにある駒
                    if opponent?(s) && s.piece.key == :knight && s.normal? # その駒は相手の駒かつ桂
                      if hand_log = executor.container.hand_logs[-1]       # それは1手前に「動かした」駒か？
                        hand_log&.move_hand&.soldier == s
                      end
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "入玉",
          description: "玉が4段目から3段目に移動した",
          func: -> {
            verify_if { soldier.just_nyuugyoku?           }
            verify_if { origin_soldier.atoippo_nyuugyoku? }
          },
        },
        {
          key: "角不成",
          description: "相手陣地に入るときと出るときの両方チェックする",
          func: -> {
            verify_if { origin_soldier.tsugini_nareru_on?(place) }
          },
        },
        {
          key: "飛車不成",
          description: "角不成と同じ方法でよい",
          func: -> {
            verify_if { origin_soldier.tsugini_nareru_on?(place) }
          },
        },
      ]
    end
  end
end
