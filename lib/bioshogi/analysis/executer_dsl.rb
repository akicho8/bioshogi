# frozen-string-literal: true

# executor メソッドに反応する (each に反応する Enumerable のように)

module Bioshogi
  module Analysis
    module ExecuterDsl
      delegate *[
        :player,                # 自分
        :drop_hand,             # 打った駒の情報
        :move_hand,             # 移動した駒の情報
        :soldier,               # 操作した駒
        :origin_soldier,        # 操作した駒 (移動元の駒)
        :captured_soldier,      # 取った駒
        :tag_bundle,            # 現在の手に結びつくタグ
      ], to: :executor

      delegate *[
        :container,             # 全部持ってるやつ
        :opponent_player,       # 相手
        :board,                 # 盤
        :location,              # 先後
        :piece_box,             # 自分の駒箱
      ], to: :player

      ################################################################################

      def perform_block
        retv = false
        catch :skip do
          yield
          retv = true
        end
        retv
      end

      def and_cond
        unless yield
          throw :skip
        end
      end

      def skip_if
        if yield
          throw :skip
        end
      end

      ################################################################################

      def cold_war_verification(e)
        # 開戦済みならskip
        # 例えばそれまで静かで始めて角交換したときは kill_count は 1 になるので outbreak_skip: nil, kill_count_lteq: 1 にしておけば skip されない
        # 0 < 1キル → skip
        # 1 < 1キル → ok
        if v = e.kill_count_lteq
          if v >= player.container.kill_count
          else
            throw :skip
          end
        end

        # 「歩と角」を除く駒が取られた場合はskip
        if e.outbreak_skip
          if player.container.outbreak_turn # 「歩と角」を除く駒が取られた手数が入っている
            throw :skip
          end
        end

        # 歩を除いて何か持っていたらskip
        if e.pawn_have_ok
          unless piece_box.except(:pawn).empty?
            throw :skip
          end
        end
      end

      # 盤上で操作し終わった駒の位置
      def place
        @place ||= soldier.place
      end

      # 後手側の場合は先手側の座標に切り替え済み
      def black_side_soldier
        @black_side_soldier ||= executor.soldier.white_then_flip
      end

      # 比較順序超重要。不一致しやすいものから比較する
      def soldier_exist?(s)
        if v = surface[s.place]
          v.piece == s.piece && v.promoted == s.promoted && v.location == s.location
        end
      end

      # place の位置に銀以上の価値がある(自分の)駒がある
      def worth_more_gteq_silver?(place)
        if v = surface[place]
          v.location == location && v.abs_weight >= silver_piece_basic_weight
        end
      end

      # place の位置に銀 or 金がある
      def silver_or_gold?(place)
        if v = surface[place]
          v.location == location && (v.piece.key == :silver || v.piece.key == :gold)
        end
      end

      # place の位置に歩以上の価値がある(自分の)駒がある
      def worth_more_gteq_pawn?(place)
        if v = surface[place]
          v.location == location
        end
      end

      # 銀の価値
      def silver_piece_basic_weight
        @silver_piece_basic_weight ||= Piece[:silver].basic_weight
      end

      # 相手の持駒
      def op_piece_box
        @op_piece_box ||= opponent_player.piece_box
      end

      # 盤面
      def surface
        @surface ||= board.surface
      end

      # soldier は相手の駒か？
      def opponent?(soldier)
        soldier.location == opponent_player.location
      end

      # soldier は自分の駒か？
      def own?(soldier)
        soldier.location == location
      end

      ################################################################################

      # 敵玉との差
      # 半径を狭めないと近づいたことにならないので manhattan_distance_a_side_max を使うこと
      def teki_king_diff
        opponent_player.king_soldier.place.then do |e|
          soldier.place.manhattan_distance_a_side_max(e) - origin_soldier.place.manhattan_distance_a_side_max(e)
        end
      end

      # 前より敵玉に近づいたか？
      def teki_king_ni_tikazuita?
        teki_king_diff < 0
      end

      # 前より敵玉から離れたか？
      def teki_king_kara_hanareta?
        teki_king_diff > 0
      end

      ################################################################################

      # 玉との差
      # 半径を狭めないと近づいたことにならないので manhattan_distance_a_side_max を使うこと
      def my_king_diff
        player.king_soldier.place.then do |e|
          soldier.place.manhattan_distance_a_side_max(e) - origin_soldier.place.manhattan_distance_a_side_max(e)
        end
      end

      # 前より敵玉に近づいたか？
      def my_king_ni_tikazuita?
        my_king_diff < 0
      end

      # 前より敵玉に離れたか？
      def my_king_kara_hanareta?
        my_king_diff > 0
      end

      ################################################################################

      # arrow のところに相手の駒がいるか？
      def op_solider_exist1(arrow)
        if v = soldier.relative_move_to(arrow)
          if s = board[v]
            opponent?(s)
          end
        end
      end

      # arrow のところに相手の成っていない piece_key がいるか？
      def op_solider_exist2(arrow, piece_key)
        if v = soldier.relative_move_to(arrow)
          if s = board[v]
            s.piece.key == piece_key && s.normal? && opponent?(s)
          end
        end
      end

      def tag_add(tag, options = {})
        tag = TagIndex.fetch(tag)

        if options[:once] && player.tag_bundle.has_tag?(tag)
          return
        end

        player.tag_bundle << tag
        tag_bundle << tag

        if v = tag.add_to_self
          player.tag_bundle << v
        end

        if v = tag.add_to_opponent
          opponent_player.tag_bundle << v
        end
      end
    end
  end
end
