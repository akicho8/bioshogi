# frozen-string-literal: true

module Bioshogi
  module Analysis
    class RocketDetector
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        perform_block do
          # 1. 「飛龍」が来たか「香」を打った
          and_cond { trigger? }

          investigate

          # 「飛龍香」が縦に2つ以上あること
          and_cond { count_all >= 2 }

          if false
            # 「飛飛」並びは除外する
            skip_if { @rook_count == 2 && @lance_count == 0 }
          end

          if false
            # 飛の下に香がある形は除外する
            # [@lance, @rook, @lance <=> @rook, soldier.location.sign_dir] # => [3, 4, -1, 1] (先手)
            # [@lance, @rook, @lance <=> @rook, soldier.location.sign_dir] # => [5, 4, 1, -1] (後手)
            # つまり ((@lance <=> @rook) + soldier.location.sign_dir).zero? のとき飛車の上に香車がいる
            skip_if do
              if @rook_count == 1 && @lance_count == 1
                ((@lance.row.top_spaces <=> @rook.row.top_spaces) + soldier.location.sign_dir).nonzero?
              end
            end
          end

          if e = TechniqueInfo[:"#{count_all}段ロケット"] # 7段以上のロケットは除外する
            tag_add(e)
          end
        end
      end

      private

      def investigate
        @rook  = nil     # 飛車の座標
        @lance = nil     # 香車の座標

        @rook_count  = 0 # 発見した飛車の個数
        @lance_count = 0 # 発見した香車の個数

        # いま打った駒が飛車か香車かで初期値を調整する

        if soldier.place != top_place # 打った位置が一番上(例えば91)ではないなら
          if soldier.piece.key == :rook
            @rook_count += 1
            @rook = soldier.place
          else
            @lance_count += 1
            @lance = soldier.place
          end
        end

        # 打った位置から上下に移動して飛車と香車の位置と個数を調べる

        [:up, :down].each do |up|
          (1..).each do |y|
            v = soldier.relative_move_to(up, magnification: y)
            unless v
              break # 盤外
            end
            if v == top_place   # 一番上(例えば91)にある飛車などは横に利かせるためのものなのでカウントしない
              break
            end
            if s = board[v]
              if opponent?(s)
                break                                   # 相手の駒
              end
              case
              when s.piece.key == :rook                 # 「飛」「龍」
                @rook_count += 1
                @rook = v
              when s.piece.key == :lance && s.normal?   # 「香」
                @lance_count += 1
                @lance = v
              else
                break                                   # 自分の「飛龍香」以外
              end
            end
          end
        end
      end

      def trigger?
        soldier.piece.key == :rook || (soldier.piece.key == :lance && soldier.normal? && drop_hand) # 「飛龍」が来たか「香」を打った
      end

      def count_all
        @rook_count + @lance_count
      end

      # 「95香」とした場合「91」の地点を返す
      def top_place
        @top_place ||= soldier.move_to_top_edge
      end
    end
  end
end
