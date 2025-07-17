# frozen-string-literal: true

# :OPTIONAL: は考慮する必要があるもの。

module Bioshogi
  module Analysis
    class MotionDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "空中戦",
          description: nil,
          trigger: [
            { piece_key: [:rook, :bishop], promoted: false, motion: :both },
          ],
          func: -> {
            # 【条件】序盤である
            and_cond { container.joban }

            # 【却下】駒を取る目的だった
            skip_if { captured_soldier }

            # 【条件】金の移動はまだ2回以内である
            and_cond { player.used_soldier_counter[:G0] <= 2 }

            # 【条件】銀の移動はまだ2回以内である
            and_cond { player.used_soldier_counter[:S0] <= 2 }

            # 【条件】両者の飛車が 4..6 行目であるかつ中央に向けて利きがある
            and_cond do
              container.players.all? do |e|
                e.soldiers_lookup2(:rook, false).any? do |e| # ここの any? は「あれば first」の意味
                  if e.middle_row?
                    if e.left_or_right
                      # 左右どちらかにいるので中央に向けて1歩移動できるか？
                      if v = e.relative_move_to(e.left_or_right_dir_to_center)
                        board.cell_empty?(v)
                      end
                    else
                      # 中央にいる
                      true
                    end
                  end
                end
              end
            end

            # 【条件】両者のどちらかの角が中央に向けて利いている
            and_cond do
              container.players.any? do |e|
                e.soldiers_lookup2(:bishop, false).any? do |e| # ここの any? は「あれば first」の意味
                  if e.middle_row? || e.bottom_spaces >= 2     # 4..6 行目または下から3行目(つまり4..7行目)
                    if e.left_or_right
                      # 中央(左上または右上)に向けて1歩移動できるか？
                      if v = e.relative_move_to(:"up_#{e.left_or_right_dir_to_center}")
                        board.cell_empty?(v)
                      end
                    else
                      # 中央にいる
                      true
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "堅陣の金",
          description: nil,
          trigger: [
            { piece_key: :gold, promoted: false, motion: :move },
          ],
          func: -> {
            # 【条件】自陣の下2行内に移動した
            and_cond { soldier.bottom_spaces <= 1 }

            # 【条件】引いた
            and_cond { move_hand.move_vector == V.down }

            # 【却下】駒を取る目的だった
            skip_if { captured_soldier }

            # 【却下】左上・上・右上に敵の駒がある
            # 本当は全面に敵駒があるかどうかではなく金が取られて損をする場合に「仕方なく引いた」ときとしたい
            skip_if do
              V.front_vectors.any? do |e|
                if v = origin_soldier.relative_move_to(e)
                  if s = board[v]
                    opponent?(s)
                  end
                end
              end
            end

            # 【却下】桂馬に狙われていた
            skip_if do
              V.keima_vectors.any? do |e|
                if v = origin_soldier.relative_move_to(e)
                  if s = board[v]
                    s.piece.key == :knight && s.normal? && opponent?(s)
                  end
                end
              end
            end
          },
        },

        {
          key: "パンドラの歩",
          description: nil,
          trigger: [
            { piece_key: :pawn, promoted: false, motion: :move },
          ],
          func: -> {
            # 【条件】序盤である
            and_cond { container.joban }

            # 【条件】下から4行目である
            and_cond { soldier.bottom_spaces == 3 }

            # 【条件】5列名である
            and_cond { soldier.column_is5? }

            # 【条件】相手が角を持っている
            and_cond { opponent_player.piece_box.has_key?(:bishop) }

            # 【条件】平手風の手合割である
            and_cond { preset_is(:hirate_like) }
          },
        },

        {
          key: "双竜双馬陣",
          description: nil,
          trigger: [
            { piece_key: :rook,   promoted: true, motion: :move },
            { piece_key: :bishop, promoted: true, motion: :move },
          ],
          func: -> {
            # 【条件】今成った
            and_cond { move_hand.promote_trigger? }

            # 【却下】すでに持っている
            skip_if { player.tag_bundle.include?("双竜双馬陣") }

            # 【条件】馬が2ついる
            and_cond { player.soldiers_lookup2(:bishop, true).size == 2 }

            # 【条件】竜2が2ついる
            and_cond { player.soldiers_lookup2(:rook, true).size == 2 }
          },
        },

        # {
        #   key: "穴熊再生",
        #   description: nil,
        #   trigger: [
        #     { piece_key: :silver, promoted: false, motion: :drop },
        #     { piece_key: :gold,   promoted: false, motion: :drop },
        #   ],
        #   func: -> {
        #     # # 【条件】平手風である
        #     # analysis { preset_has(:hirate_like) }
        #
        #     # 【条件】自玉が1つ存在する
        #     and_cond { player.king_soldier_only_one_exist? }
        #
        #     # 【条件】自玉が隅にいる
        #     and_cond { player.king_soldier.side_edge? && player.king_soldier.bottom_spaces == 0 }
        #
        #     # 【条件】打った駒は玉と同じ側である
        #     and_cond { soldier.left_or_right == player.king_soldier.left_or_right }
        #
        #     # 【条件】打った駒は玉の近くである (3x3)
        #     and_cond { soldier.place.in_outer_area?(player.king_soldier.place, 2) }
        #   },
        # },
        {
          key: "ハッチ閉鎖",
          description: "穴熊を金銀で閉鎖したタイミングで発動する",
          trigger: [
            { piece_key: :silver, promoted: false, motion: :move },
            { piece_key: :gold,   promoted: false, motion: :move },
          ],
          func: -> {
            # 【却下】すでに開戦している
            skip_if { container.outbreak_turn }

            # 【条件】下から2行目である
            and_cond { soldier.bottom_spaces == 1 }

            # 【条件】端から2列目である
            and_cond { soldier.left_right_space_min == 1 }

            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【条件】移動先の壁側の斜め下に自玉がいる
            and_cond do
              if v = soldier.relative_move_to(:"down_#{soldier.left_or_right}")
                if s = board[v]
                  s.piece.key == :king && own?(s)
                end
              end
            end

            # 【条件】移動先の壁側と上下に味方がいる
            and_cond do
              [soldier.left_or_right, :up, :down].all? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    own?(s)
                  end
                end
              end
            end
          },
        },
        {
          key: "突き捨て",
          description: nil,
          trigger: { piece_key: :pawn, promoted: false, motion: :move },
          func: -> {
            # 【却下】駒を取った
            skip_if { captured_soldier }

            # 【条件】4..5段目
            and_cond { soldier.row_is_4to5? }

            # 【条件】上に敵の歩がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "退場の金",
          description: nil,
          trigger: { piece_key: :gold, promoted: false, motion: :move },
          func: -> {
            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【条件】左上か右上に移動した
            and_cond { move_hand.right_move_length.abs.positive? && move_hand.up_move_length.positive? }

            # 【条件】下に歩がある
            and_cond do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && own?(s)
                end
              end
            end

            # 【条件】移動してきた側に歩がある
            and_cond do
              dir = move_hand.right_move_length > 0 ? :left : :right
              if v = soldier.relative_move_to(dir)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && own?(s)
                end
              end
            end

            # 【条件】自玉から離れた
            and_cond { my_king_kara_hanareta? }
          },
        },
        {
          key: "右玉",
          description: nil,
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】玉の初回移動に限る
            and_cond { player.used_soldier_counter[:K0] == 1 }

            # 【条件】序盤である
            and_cond { container.joban }

            # 【条件】右に移動した
            and_cond { move_hand.right_move_length.positive? }

            # 【条件】28 か 29 に自分の飛車がある
            and_cond do
              ["28", "29"].any? do |e|
                if s = board[Place[e].white_then_flip(location)]
                  s.piece.key == :rook && s.normal? && own?(s)
                end
              end
            end
          },
        },
        {
          key: "歩の錬金術師",
          description: nil,
          trigger: { piece_key: :pawn, promoted: true, motion: :move },
          func: -> {
            # 【条件】成ったタイミング
            and_cond { move_hand.promote_trigger? }

            # 【却下】すでに持っている
            skip_if { player.tag_bundle.include?("歩の錬金術師") }

            # 【条件】たくさん「と金」を作った (盤上にある)
            and_cond do
              player.soldiers_lookup2(:pawn, true).size >= 3
            end

            # 【条件】たくさん「と金」を作った (盤上にある)
            # and_cond do
            #   max = 3
            #   found = false
            #   count = 0
            #   player.soldiers.each do |e|
            #     if e.piece.key == :pawn && e.promoted
            #       count += 1
            #       if count >= max
            #         found = true
            #         break
            #       end
            #     end
            #   end
            #   found
            # end
          },
        },
        {
          key: "蓋歩",
          description: "飛車を帰らせない",
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】打った歩の下には、1手前に相手の飛車が移動してきていて、その飛車の前方1マスは空いている
            and_cond do
              if hand_log = previous_hand_log(1)
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

            # 【条件】その歩は桂か銀に支えられている
            and_cond do
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
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】「最下段」である
            and_cond { soldier.bottom_spaces.zero? }

            # 【条件】上に自分の金がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :gold && own?(s)
                end
              end
            end
          },
        },
        {
          key: "金底の香",
          description: nil,
          trigger: { piece_key: :lance, promoted: false, motion: :drop },
          func: -> { instance_exec(&MotionDetector[:"金底の歩"].func) },
        },
        {
          key: "一間竜",
          description: "上下左右の1つ離れたところのどこかに敵玉がある",
          trigger: { piece_key: :rook, promoted: true,  motion: :move },
          func: -> {
            and_cond do
              V.ikkenryu_cross_vectors.any? do |e|
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
          key: "自陣飛車",
          description: nil,
          trigger: { piece_key: :rook, promoted: false, motion: :drop },
          func: -> {
            and_cond { soldier.own_side? }
          },
        },
        {
          key: "自陣角",
          description: nil,
          trigger: { piece_key: :bishop, promoted: false, motion: :drop },
          func: -> {
            and_cond { soldier.own_side? }
          },
        },
        {
          key: "角頭攻め",
          description: nil,
          trigger: { piece_key: :pawn, promoted: false, motion: :both },
          func: -> {
            and_cond do
              v = false

              # 【OR条件】対象を直接攻めている
              v ||= op_solider_exist2(:up, :bishop)

              # 【OR条件】角の上の歩を攻めている
              #
              # 次のように単に「角の上の歩」に対して「歩」を突いた場合としてしまうと初形の飛車先の歩交換で角頭攻めになってしまう
              #
              # > v銀v桂v香
              # >    v角
              # > v歩v歩v歩
              # >     歩
              #
              v ||= yield_self do
                if soldier.not_own_side?                  # 自分の陣地より上(これをしないとお手伝いになってしまう)
                  if op_solider_exist2(:up, :pawn)        # 歩を攻めている
                    if op_solider_exist2(:up_up, :bishop) # 歩の奥に角がある
                      # 「序盤の24歩」ではないこと
                      !(container.joban && soldier.column_eq?(2) && soldier.next_nyugyoku?)
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "桂頭攻め",
          description: nil,
          trigger: { piece_key: :pawn, promoted: false, motion: :both },
          func: -> {
            and_cond do
              v = false

              # 【OR条件】対象を直接攻めている
              v ||= op_solider_exist2(:up, :knight)

              # 【OR条件】桂の上の歩を攻めている
              v ||= yield_self do
                if soldier.not_own_side?                 # 自分の陣地よりむこう(これをしないとお手伝いになってしまう)
                  if soldier.not_opp_side?               # 相手の陣地よりこっち(23歩は桂を攻めている感じがしないため)
                    if op_solider_exist2(:up, :pawn)     # 歩を攻めている
                      op_solider_exist2(:up_up, :knight) # 歩の奥に桂がある
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "玉頭攻め",
          description: "角頭攻めとは条件を変えている",
          trigger: { piece_key: :pawn, promoted: false, motion: :both },
          func: -> {
            # 【条件】「玉頭」または「玉頭の何かの駒」を攻めている
            and_cond do
              op_solider_exist2(:up, :king) || (op_solider_exist1(:up) && op_solider_exist2(:up_up, :king))
            end
          },
        },
        {
          key: "こびん攻め",
          description: "玉または飛の斜めの歩を攻める",
          trigger: { piece_key: :pawn, promoted: false, motion: :both },
          func: -> {
            # 【条件】2〜8筋である (端の場合は「こびん」とは言わないため)
            and_cond { soldier.column_is2to8? }

            # 【条件】相手が歩である
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件】桂馬の効きの位置に「玉」または「飛車」がある
            and_cond do
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
          key: "と金攻め",
          description: nil,
          trigger: { piece_key: :pawn, promoted: true,  motion: :move },
          func: -> {
            # 【却下】歩成り
            skip_if { origin_soldier.normal? }

            # 【条件】駒を取っている
            and_cond { captured_soldier }

            # 【条件】取った駒の価値が「盤上の歩」より高い (相手の歩を取ったところで効果はない)
            and_cond { captured_soldier.abs_weight > Piece.fetch(:pawn).basic_weight }

            # 【条件】敵玉が1つ存在する
            and_cond { opponent_player.king_soldier_only_one_exist? }

            # 【条件】移動先の近くに敵玉がいる (半径3)
            and_cond { soldier.place.in_outer_area?(opponent_player.king_soldier.place, 3) }

            # 【条件】相手玉に向かって進んでいる (玉と反対に移動したら駒を取ったとしても戦力低下になる場合もある)
            and_cond { teki_king_ni_tikazuita? }
          },
        },
        {
          key: "位の確保",
          description: "中盤戦になる前に5行目の歩を銀で支える",
          trigger: { piece_key: :silver, promoted: false, motion: :move },
          func: -> {
            # 【却下】すでに開戦している
            skip_if { container.outbreak_turn }

            # 【条件】前線(6行目)にいる
            and_cond { soldier.kurai_sasae? }

            # 【条件】3〜7列である (両端2列は「位」とは言わないため)
            and_cond { soldier.column_is3to7? }

            # 【条件】前に歩がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && own?(s)
                end
              end
            end

            # 【却下】上の上(つまり歩の上)に何かある
            skip_if do
              if v = soldier.relative_move_to(:up_up)
                board[v]
              end
            end
          },
        },
        {
          key: "突き違いの歩",
          trigger: { piece_key: :pawn, promoted: false, motion: :move },
          func: -> {
            # 【却下】駒を取った
            skip_if { captured_soldier }

            # 【条件】歩の前に敵銀がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :silver && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件】1手前、隣に相手の歩が突かれた
            and_cond do
              if hand_log = previous_hand_log(1)
                if s = hand_log.move_hand&.soldier
                  Assertion.assert { opponent?(s) }
                  if s.piece.key == :pawn && s.normal?                   # 歩
                    if s.place.row == soldier.place.row                  # 行が同じ
                      s.place.column.distance(soldier.place.column) <= 1 # 列の差が1以下。つまり左右以内。
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "浮き飛車",
          description: "戻る場合も考慮する",
          trigger: { piece_key: :rook, promoted: false, motion: :move },
          func: -> {
            # 【却下】すでに開戦している
            skip_if { container.outbreak_turn }

            # 【条件】前線(6行目)にいる
            and_cond { soldier.funoue_line_ni_uita? }

            # 【条件】移動元と同じ列であること
            and_cond { soldier.place.column == origin_soldier.place.column }

            # 【却下】同飛 (相手の駒を取る目的で移動していない)
            skip_if { captured_soldier }
          },
        },
        {
          key: "二枚飛車",
          description: "二枚飛車の間の駒が動いたら二枚飛車になる場合には対応していない",
          trigger: { piece_key: :rook, promoted: :both, motion: :both },
          func: -> {
            # 【条件】敵玉が1つ存在する
            and_cond { opponent_player.king_soldier_only_one_exist? }

            # 【条件】敵玉と行が同じ (許容誤差±1)
            and_cond { (opponent_player.king_soldier.place.row.value - soldier.place.row.value).abs <= 1 }

            if false
              # # 富豪的な配列プログラミング
              #
              # # 【条件】自分の飛車(龍を含む)が盤上に複数ある
              # and_cond { player.soldiers_lookup1(:rook).many? }
              #
              # # 【条件】自分の飛車(龍を含む)が同じ行にある
              # and_cond { player.soldiers_lookup1(:rook).collect { |s| s.place.row }.uniq.one? }
            else
              # 2つあるとして比較する方法
              soldiers = player.soldiers_lookup1(:rook)
              partner = (soldiers - [soldier]).first

              # 【条件】もう一方の飛車が存在する
              and_cond { partner }

              # 【条件】もう一方の飛車と同じ行にある (この方法は遮る駒のチェックを行えない)
              and_cond { soldier.place.row == partner.place.row }

              # 【却下】移動してきた場合、移動元はもう一方の飛車と同じ行にある (この方法は遮る駒のチェックを行えない)
              skip_if do
                if s = origin_soldier
                  s.place.row == partner.place.row
                end
              end
            end

            # 【条件】打った飛車の左右に自分の飛車がいる (この方法は遮る駒のチェックを行える)
            # and_cond do
            #   [:left, :right].any? do |left_or_right|
            #     found = false
            #     (1..).each do |x|
            #       v = soldier.relative_move_to(left_or_right, magnification: x)
            #       unless v
            #         break # 盤外
            #       end
            #       if s = board[v]
            #         if opponent?(s)
            #           break                                   # 相手の駒が間にあるとだめ
            #         end
            #         if s.piece.key == :rook                   # 「飛」「龍」
            #           found = true
            #           break
            #         else
            #           break                                   # 自分の他の駒が間にあるとだめ
            #         end
            #       else
            #         # 何もない
            #       end
            #     end
            #     found
            #   end
            # end
          },
        },
        {
          key: "裸玉",
          description: "玉のまわりに歩ぐらいしかない",
          trigger: [
            { piece_key: :king, promoted: false, motion: :move },
          ],
          func: -> {
            min_score = Piece[:lance].basic_weight

            # 【却下】移動先が潤っている
            skip_if do
              V.outer_vectors.any? do |e|
                if v = soldier.relative_move_to(e)
                  if s = board[v]
                    if own?(s)
                      s.abs_weight >= min_score
                    end
                  end
                end
              end
            end

            # 【条件】移動元が潤っている (移動先の玉が近くにいるため除外すること)
            and_cond do
              V.outer_vectors.any? do |e|
                if v = origin_soldier.relative_move_to(e)
                  if s = board[v]
                    if own?(s)
                      if s.piece.key != :king
                        s.abs_weight >= min_score
                      end
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "飛車先交換",
          description: nil,
          trigger: [
            { piece_key: :rook, promoted: false, motion: :move },
          ],
          func: -> {
            # 1手前: △２四歩(23)
            and_cond do
              if hand_log = previous_hand_log(1)
                if s = hand_log.move_hand&.soldier
                  Assertion.assert { opponent?(s) }
                  s.piece.key == :pawn && s.place == soldier.place
                end
              end
            end

            # 2手前: ▲２四歩(25)
            and_cond do
              if hand_log = previous_hand_log(2)
                if s = hand_log.move_hand&.soldier
                  Assertion.assert { own?(s) }
                  s.piece.key == :pawn && s.place == soldier.place
                end
              end
            end
          },
        },
        {
          key: "玉飛接近",
          description: "龍は馬と似て守りに効いている場合もあるため接近してもよいとする",
          trigger: [
            { piece_key: :rook, promoted: false, motion: :move },
            { piece_key: :king, promoted: false, motion: :move },
          ],
          func: -> {
            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【却下】玉と飛の移動が合わせて2回以下 (これがあれば中飛車美濃囲いのときに玉飛接近にならない)
            skip_if { (player.used_soldier_counter[:K0] + player.used_soldier_counter[:R0]) <= 2 }

            fn = -> it {
              partner = it.piece.key == :rook ? :king : :rook
              V.outer_vectors.any? do |e|
                if v = it.relative_move_to(e)
                  if s = board[v]
                    s.piece.key == partner && s.normal? && own?(s)
                  end
                end
              end
            }

            # 【条件】移動先の周囲に相手がいる
            and_cond { fn[soldier] }

            # 【スキップスキプ条件】移動元の周囲に相手がいる
            skip_if { fn[origin_soldier] }
          },
        },
        {
          key: "端攻め",
          description: nil,
          trigger: [
            { piece_key: :pawn, promoted: false, motion: :move },
          ],
          func: -> {
            # 【条件】端である
            and_cond { soldier.side_edge? }

            # 【条件】上が敵歩である
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end

            # 【却下】駒を取る目的で突いた
            skip_if { captured_soldier }
          }
        },
        # {
        #   key: "守りの馬",
        #   description: nil,
        #   trigger: { piece_key: :bishop, promoted: true,  motion: :move },
        #   func: -> {
        #     # 【条件】自玉が1つ存在する
        #     and_cond { player.king_soldier_only_one_exist? }
        #
        #     # 【条件】移動先の近くに自玉がいる
        #     and_cond { soldier.place.in_outer_area?(player.king_soldier.place, 2) }
        #
        #     # 【却下】移動元の近くに、すでに自玉がいる
        #     skip_if { origin_soldier.place.in_outer_area?(player.king_soldier.place, 2) }
        #   },
        # },
        # {
        #   key: "双馬結界",
        #   description: nil,
        #   trigger: { piece_key: :bishop, promoted: true,  motion: :move },
        #   func: -> {
        #     # 【条件】自玉が1つ存在する
        #     and_cond { player.king_soldier_only_one_exist? }
        #
        #     # 【条件】移動先の近くに自玉がいる
        #     and_cond { soldier.place.in_outer_area?(player.king_soldier.place, 2) }
        #
        #     # 【却下】移動元の近くに、すでに自玉がいる
        #     skip_if { origin_soldier.place.in_outer_area?(player.king_soldier.place, 2) }
        #   },
        # },
        {
          key: "双玉接近",
          description: nil,
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】敵玉が1つ存在する
            and_cond { opponent_player.king_soldier_only_one_exist? }

            # 【条件】移動先の近くに敵玉がいる
            and_cond { soldier.place.in_outer_area?(opponent_player.king_soldier.place, 2) }

            # 【却下】移動元の近くに敵玉がいる
            skip_if { origin_soldier.place.in_outer_area?(opponent_player.king_soldier.place, 2) }
          },
        },
        # {
        #   key: "玉頭戦",
        #   description: nil,
        #   trigger: { piece_key: :king, promoted: false, motion: :move },
        #   func: -> {
        #     # 【条件】敵玉が1つ存在する
        #     and_cond { opponent_player.king_soldier_only_one_exist? }
        # 
        #     # 【条件】同じ列か1つずれの状態かつ、行の差が4以内である(間が5マス以内)
        #     fn = -> soldier {
        #       vector = soldier.place.vector_from(opponent_player.king_soldier.place)
        #       p ["#{__FILE__}:#{__LINE__}", __method__, vector]
        #       vector.x.abs <= 1 && vector.y.abs <= 6
        #     }
        #     and_cond { fn[soldier] }
        # 
        #     # 【却下】すでに玉頭戦状態だった
        #     skip_if { fn[origin_soldier] }
        #   },
        # },
        {
          key: "天空の城",
          description: nil,
          trigger: [
            { piece_key: :king,   promoted: false, motion: :move },
            { piece_key: :silver, promoted: true,  motion: :move },
            { piece_key: :gold,   promoted: false, motion: :both },
          ],
          func: -> {
            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【条件】自玉は4から6行目にいる
            and_cond { player.king_soldier.middle_row? }

            # 【却下】すでに持っている
            skip_if { player.tag_bundle.include?("天空の城") }

            # 【条件】移動先の近くに自玉がいる (半径1)
            and_cond { soldier.place.in_outer_area?(player.king_soldier.place, 1) }

            # 【条件】自玉のまわりに価値のある駒がある
            and_cond do
              min_score = ClusterScoreInfo["天空の城構成員"].min_score
              score = 0
              V.outer_vectors.any? do |e|
                if v = player.king_soldier.relative_move_to(e)
                  if s = board[v]
                    if own?(s)
                      score += s.abs_weight
                      score >= min_score
                    end
                  end
                end
              end
            end

            # 【必要条件6】駒得している
            and_cond { player.current_score > opponent_player.current_score }
          },
        },
        {
          key: "端玉",
          description: "端に入ったときだけ判定する",
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】左右の端 (かどを除く) に移動した
            and_cond { soldier.both_side_without_corner? }

            # 【却下】移動元が左右の端 (かどを除く)
            skip_if { origin_soldier.both_side_without_corner? }
          },
        },
        {
          key: "中段玉",
          description: nil,
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】移動元は自陣にいる
            and_cond { origin_soldier.own_side? }

            # 【条件】移動先に自陣にいない
            and_cond { soldier.not_own_side? }
          },
        },
        {
          key: "パンティを脱ぐ",
          description: "開戦前かつ、跳んだ桂が下から3つ目かつ、(近い方の)端から3列目かつ、移動元の隣(端に近い方)に自玉がある",
          trigger: { piece_key: :knight, promoted: false, motion: :move },
          func: -> {
            # 【却下】すでに開戦している
            skip_if { container.outbreak_turn }

            # 【条件】下から3行目である
            and_cond { soldier.bottom_spaces == 2 }

            # 【条件】端から3列目である
            and_cond { soldier.left_right_space_min == 2 }

            # 【条件】移動元は「端から2列目」である (▲41から飛んだ場合を除外している)
            and_cond { origin_soldier.left_right_space_min == 1 }

            # 【条件】移動元の端側に自玉がいる
            and_cond do
              if v = origin_soldier.relative_move_to(origin_soldier.left_or_right)
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
          description: "銀を打ったか移動させたとき左右どちらかに敵玉がある",
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          description: "銀を打ったか移動させたとき下に敵玉がある",
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
              V.bishop_up_diagonal_vectors.any? do |up_left|
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
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          description: "銀を打ったか移動させたとき前に敵玉がある",
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          description: "金を打ったか移動させたとき左右どちらかに敵玉がある",
          trigger: { piece_key: :gold, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"腹銀"].func) },
        },
        {
          key: "尻金",
          description: "金を打ったか移動させたとき下に敵玉がある",
          trigger: { piece_key: :gold, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"尻銀"].func) },
        },
        {
          key: "肩金",
          description: "金を打ったか移動させたとき左斜め前か右斜め前に玉がある",
          trigger: { piece_key: :gold, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"肩銀"].func) },
        },
        {
          key: "裾金",
          description: "金を打ったか移動させたとき左斜め後か右斜め後に玉がある",
          trigger: { piece_key: :gold, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"裾銀"].func) },
        },
        {
          key: "頭金",
          description: "金を打ったか移動させたとき前に敵玉がある",
          trigger: { piece_key: :gold, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"頭銀"].func) },
        },

        ################################################################################

        {
          key: "垂れ歩",
          description: "打った歩の前が空で次に成れる余地がある場合",
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】2, 3, 4 行目である
            and_cond { soldier.tarefu_desuka? }

            # 【条件】先が空である
            and_cond do
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
          trigger: { piece_key: :bishop, promoted: false, motion: :both },
          func: -> {
            # 【条件】中盤以降である (そうしないと序盤の77角打まで該当してしまう) :OPTIONAL:
            and_cond { container.outbreak_turn }

            # 【条件】自陣から打っている
            and_cond { soldier.own_side? }

            # 【条件】端から打っている
            if false
              and_cond { soldier.side_edge? }
            end

            # 【条件】相手の陣地に直通しているかつ長さが 5 以上である
            and_cond do
              threshold = 5                                       # 成立するステップ数。4 だとマッチしすぎるため 5 にする
              V.bishop_up_diagonal_vectors.any? do |up_left|       # 左上と右上を試す
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
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :bishop, promoted: false, motion: :both },
          func: -> { instance_exec(&MotionDetector[:"たすきの銀"].func) },
        },
        {
          key: "壁金",
          description: "飛車や角の位置に玉よりも先に金が移動した",
          trigger: { piece_key: :gold, promoted: false, motion: :move },
          func: -> {
            # 【条件】端から2列目である
            and_cond { soldier.left_right_space_min == 1 }

            # 【条件】下から2行目である
            and_cond { soldier.bottom_spaces == 1 }

            # 【条件】下に桂がある
            and_cond do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  s.piece.key == :knight && own?(s)
                end
              end
            end

            # 【条件】上に歩がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && own?(s)
                end
              end
            end

            # 【条件】移動元は端から3列目である
            and_cond { origin_soldier.left_right_space_min == 2 }

            # 【必要条件6】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【必要条件7】玉との横軸の距離は3以内である (最長3 = 居玉) 銀と同じ方向に玉がいるというだけで穴熊状態の可能性もある
            and_cond { soldier.place.column.distance(player.king_soldier.place.column) <= 3 }

            # 【必要条件8】玉は中心から2以内にいる = 銀より内側にいる (居玉 = 0, 早囲い = 2, 美濃囲い = 3, 穴熊 = 4)
            and_cond { player.king_soldier.place.column.distance_from_center <= 3 }

            # 【必要条件9】玉は自分の陣地にいる
            and_cond { player.king_soldier.own_side? }
          },
        },
        {
          key: "壁銀",
          description: "飛車や角の位置に玉よりも先に銀が移動した",
          trigger: { piece_key: :silver, promoted: false, motion: :move },
          func: -> { instance_exec(&MotionDetector[:"壁金"].func) },
        },
        {
          key: "桂頭の銀",
          description: "打った銀の上に相手の桂がある",
          trigger: { piece_key: :silver, promoted: false, motion: :both },
          func: -> {
            # 【条件】上に相手の桂がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :knight && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件】「22銀」や「82銀」ではない :OPTIONAL:
            # - 端玉に対しての腹銀が「桂頭の銀」扱いになる場合が多いため除外している
            # - ただ本当に21や81の桂に対して「桂頭の銀」をかましている場合もなくはない
            skip_if do
              soldier.column_is2or8? && soldier.top_spaces == 1
            end
          },
        },
        {
          key: "桂頭の玉",
          description: "「桂頭の玉、寄せにくし」の略",
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】上に相手の桂がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :knight && s.normal? && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "歩頭の桂",
          description: "打ったまたは移動した桂の上に相手の歩がある",
          trigger: { piece_key: :knight, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :knight, promoted: false, motion: :both },
          func: -> {
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :gold && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "桂頭の桂",
          description: nil,
          trigger: { piece_key: :knight, promoted: false, motion: :both },
          func: -> {
            # 【条件】上に相手の桂がある
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :knight && s.normal? && opponent?(s)
                end
              end
            end
          },
        },
        {
          key: "銀ばさみ",
          description: "動かした歩の左右どちらかに相手の銀があり、その向こうに自分の歩がある。また歩の前に何もない。",
          trigger: { piece_key: :pawn, promoted: false, motion: :both },
          func: -> {
            # 【却下】すでに開戦している
            skip_if { container.outbreak_turn }

            # 【却下】同歩
            skip_if { captured_soldier }

            # 【条件】進めた歩の前が空である
            and_cond do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end

            # 左右どちらかが成立している
            and_cond do
              V.ginbasami_verctors.any? do |right, right_right, right_right_up|
                # 【条件】右に相手の銀ある
                yield_self {
                  if v = soldier.relative_move_to(right)
                    if s = board[v]
                      s.piece.key == :silver && s.normal? && opponent?(s)
                    end
                  end
                } or next

                # 【条件】右右に自分の歩がある
                yield_self {
                  if v = soldier.relative_move_to(right_right)
                    if s = board[v]
                      s.piece.key == :pawn && s.normal? && own?(s)
                    end
                  end
                } or next

                # 【条件】右右上が空である
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
          trigger: { piece_key: :pawn, promoted: false, motion: :move },
          func: -> {
            # 【条件】敵玉が1つ存在する
            and_cond { opponent_player.king_soldier_only_one_exist? }

            # 【条件】端である
            and_cond { soldier.side_edge? }

            # 【条件】上が相手の歩である (▲16歩△14歩の状態で▲15歩としたということ)
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  s.piece.key == :pawn && s.normal? && opponent?(s)
                end
              end
            end

            # 【条件】奥に敵玉がいる (13→12→11と探す)
            and_cond do
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

            # 【条件】下に「自分の香飛龍」 (17→18→19と探す)
            and_cond do
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
          key: "歩切れ",
          description: "中盤以降に絞らないとタグを入れる意味がない",
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】中盤以降である
            and_cond { container.outbreak_turn }

            # 【却下】歩がある
            skip_if { player.piece_box.has_key?(:pawn) }
          },
        },
        {
          key: "田楽刺し",
          description: "角の頭に打ってその奥に玉などの大駒がある。「底歩に香」の手筋があるためこれは角のみを対象とする",
          trigger: { piece_key: :lance,  promoted: false, motion: :drop },
          func: -> {
            and_cond do
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
          key: "底歩に香",
          description: nil,
          trigger: { piece_key: :lance,  promoted: false, motion: :drop },
          func: -> {
            # 【条件】底歩がある
            and_cond do
              if s = board[soldier.move_to_top_edge]
                s.piece.key == :pawn && s.normal? && opponent?(s)
              end
            end

            # 【条件】そこ歩の上に金がある
            and_cond do
              if s = board[soldier.move_to_top_edge]
                if v = s.relative_move_to(:up)
                  if s = board[v]
                    s.piece.key == :gold && opponent?(s)
                  end
                end
              end
            end

            # 【条件】打った香車の1つ前の升目が空いている
            and_cond do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end

            # 【条件】敵金まで香が通っている
            and_cond do
              found = false
              (1..).each do |y|
                if v = soldier.relative_move_to(:up, magnification: y)
                  if s = board[v]
                    if opponent?(s)
                      if s.bottom_spaces == 1 # つまり金である
                        found = true
                      end
                    else
                      # 自分の駒が間にある場合は香が相手まで通っていない
                      break
                    end
                  else
                    # 駒がない場合はさらに奥に進む
                  end
                else
                  # 盤の外に出た場合は終わる(前の条件があるので、ここに来ることはない)
                  break
                end
              end
              found
            end
          },
        },
        {
          # https://yokohamayanke.com/1078/ によると金底の香の状態でも「下段の香」として紹介されている
          # いろんな条件を考えたが結局「下段」のみのチェックとする
          key: "下段の香",
          description: "打った香が一番下",
          trigger: { piece_key: :lance,  promoted: false, motion: :drop },
          func: -> {
            # 【条件】「最下段」である
            and_cond { soldier.bottom_spaces.zero? }
          },
        },
        {
          key: "歩裏の香",
          description: nil,
          trigger: { piece_key: :lance,  promoted: false, motion: :drop },
          func: -> {
            # 【条件】下(方向)に相手の歩がある
            and_cond do
              found = false
              Dimension::Row.dimension_size.times do |i|
                if v = soldier.relative_move_to(:down, magnification: 1 + i)
                  if s = board[v]
                    if s.piece.key == :pawn && s.normal? && opponent?(s)
                      found = true
                      break
                    end
                  end
                else
                  break
                end
              end
              found
            end
          },
        },
        {
          key: "歩裏の歩",
          description: nil,
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> { instance_exec(&MotionDetector[:"歩裏の香"].func) },
        },
        {
          key: "マムシのと金",
          description: nil,
          trigger: { piece_key: :pawn, promoted: true,  motion: :move },
          func: -> {
            # 【条件】移動元の駒は「と」である (すでに成っている)
            and_cond { origin_soldier.promoted }

            # 【条件】敵玉が1つ存在する
            and_cond { opponent_player.king_soldier_only_one_exist? }

            # 【条件】敵玉に近づく
            and_cond { teki_king_ni_tikazuita? }

            # 【却下】駒を取っている (意図して近づいてはいないため)
            skip_if { captured_soldier }
          },
        },

        {
          key: "ふんどしの桂",
          description: "打った桂の2つ前の左右に自分より価値の高い相手の駒がある",
          trigger: { piece_key: :knight, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :knight, promoted: false, motion: :drop },
          func: -> {
            # 【条件】打った位置が6行目以降である
            and_cond { soldier.top_spaces >= Dimension::Row.promotable_depth + 2 }

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

            # 【条件】 相手の駒は1つ以上ある
            and_cond { !soldiers.empty? }

            # 【条件】 相手の駒は「歩」である
            and_cond do
              soldiers.all? { |e| e.piece.key == :pawn }
            end
          },
        },
        {
          key: "高跳びの桂",
          description: nil,
          trigger: { piece_key: :knight, promoted: false, motion: :move },
          func: -> {
            # 【条件】奇数列である
            and_cond { soldier.place.column.value.odd? }

            # 【条件】位の行である
            and_cond { soldier.kurai? }
          },
        },
        {
          key: "土下座の歩",
          description: nil,
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】8,9行目である
            and_cond { soldier.bottom_spaces < 2 }

            # 【条件】一つ上が空である
            and_cond do
              if v = soldier.relative_move_to(:up)
                board.cell_empty?(v)
              end
            end

            # 【条件】二つ上に相手の前に進める駒がある (成銀や馬があっても土下座の対象とする)
            and_cond do
              if v = soldier.relative_move_to(:up_up)
                if s = board[v]
                  if opponent?(s)
                    s.piece.forward_movable || s.promoted
                  end
                end
              end
            end
          },
        },
        {
          key: "たたきの歩",
          description: "取ると取り返せるような場合もたたきの歩として判別されるのであまり正しくない",
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 【条件】打った位置が1から4行目である
            and_cond { soldier.top_spaces.between?(1, Dimension::Row.promotable_depth) }

            # 【条件】相手が「成駒」または「飛金銀香玉」である
            and_cond do
              if v = soldier.relative_move_to(:up)
                if s = board[v]
                  if opponent?(s)
                    s.promoted || s.piece.tatakare_target
                  end
                end
              end
            end

            # 【却下】打った歩に結びついている利きがある (これはたたきというより打ち込みのため)
            # 本当はすべての利きを調べてないといけないのだけど重くなるので、
            # 「打った位置の後ろに自分の(前に進めることのできる)駒がない」だけを判定している
            skip_if do
              if v = soldier.relative_move_to(:down)
                if s = board[v]
                  if own?(s)
                    s.promoted || s.piece.forward_movable
                  end
                end
              end
            end

            # 【却下】連打の歩 :OPTIONAL:
            skip_if do
              if hand_log = previous_hand_log(2) # 前回の自分の手
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
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            # 2手前: ▲24歩(25) 突き
            and_cond do
              if hand_log = previous_hand_log(2)
                if s = hand_log.move_hand&.soldier # 最初を突き捨てとするため hand ではなく move_hand にしている
                  if s.piece.key == :pawn && s.normal? && own?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end

            # 1手前: △24同歩 取らされる
            and_cond do
              if hand_log = previous_hand_log(1)
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
          trigger: { piece_key: :pawn, promoted: false, motion: :drop },
          func: -> {
            # 0手前: ▲25歩打 継ぎ歩 したらここに来る

            # 2手前: ▲24歩打
            and_cond do
              if hand_log = previous_hand_log(2)
                if s = hand_log.drop_hand&.soldier
                  if s.piece.key == :pawn && own?(s)
                    s.place == soldier.relative_move_to(:up)
                  end
                end
              end
            end

            # 1手前: △24同何か 取らされる
            and_cond do
              if hand_log = previous_hand_log(1)
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
          trigger: { piece_key: :knight, promoted: false, motion: :both },
          func: -> {
            and_cond do
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
          trigger: { piece_key: :knight, promoted: :both, motion: :move },
          func: -> {
            and_cond do
              # △33桂(21)▲13桂成(25)で考える
              # 跳ね違いは相手の桂を捌けなくする目的でもあるため「成っていない桂」のチェックとする
              V.keima_vectors.any? do |e|
                if v = origin_soldier.relative_move_to(e)                  # 25から33と13を見る
                  if s = board[v]                                          # そこにある駒
                    if opponent?(s) && s.piece.key == :knight && s.normal? # その駒は相手の駒かつ桂
                      if hand_log = previous_hand_log(1)       # それは1手前に「動かした」駒か？
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
          description: "玉が4行目から3行目に移動した",
          trigger: { piece_key: :king, promoted: false, motion: :move },
          func: -> {
            # 【条件】3行目に移動する
            and_cond { soldier.just_nyuugyoku?           }

            # 【条件】4行目から移動する
            and_cond { origin_soldier.next_nyugyoku? }
          },
        },
        {
          key: "角不成",
          description: "相手陣地に入るときと出るときの両方チェックする",
          trigger: { piece_key: :bishop, promoted: false, motion: :move },
          func: -> {
            and_cond { origin_soldier.tsugini_nareru_on?(place) }
          },
        },
        {
          key: "飛車不成",
          description: "角不成と同じ方法でよい",
          trigger: { piece_key: :rook, promoted: false, motion: :move },
          func: -> {
            and_cond { origin_soldier.tsugini_nareru_on?(place) }
          },
        },
        {
          key: "銀不成",
          description: "角不成と同じ方法でよい",
          trigger: { piece_key: :silver, promoted: false, motion: :move },
          func: -> {
            and_cond { origin_soldier.tsugini_nareru_on?(place) }
          },
        },

        ################################################################################
      ]
    end
  end
end
# ~> -:8:in '<class:MotionDetector>': uninitialized constant Bioshogi::Analysis::MotionDetector::ApplicationMemoryRecord (NameError)
# ~>    from -:7:in '<module:Analysis>'
# ~>    from -:6:in '<module:Bioshogi>'
# ~>    from -:5:in '<main>'
