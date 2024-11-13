# frozen-string-literal: true

module Bioshogi
  module Analysis
    class RocketAnalyzer
      DEBUG = false

      delegate *[
        :executor,
        :soldier,
        :board,
        :drop_hand,
        :opponent?,
        :verify_if,
        :skip_if,
      ], to: :@analyzer

      def initialize(analyzer)
        @analyzer = analyzer
      end

      def call
        catch :skip do
          # 1. 「飛龍」が来たか「香」を打った
          verify_if { trigger? }

          investigate

          # 「飛龍香」が縦に2つ以上あること
          verify_if { count_all >= 2 }

          # 「飛飛」並びは除外する
          skip_if { @rook_count == 2 && @lance_count == 0 }

          # 飛の下に香がある形は除外する
          # [@lance, @rook, @lance <=> @rook, soldier.location.sign_dir] # => [3, 4, -1, 1] (先手)
          # [@lance, @rook, @lance <=> @rook, soldier.location.sign_dir] # => [5, 4, 1, -1] (後手)
          # つまり ((@lance <=> @rook) + soldier.location.sign_dir).zero? のとき飛車の上に香車がいる
          skip_if do
            if @rook_count == 1 && @lance_count == 1
              ((@lance.row.value <=> @rook.row.value) + soldier.location.sign_dir).nonzero?
            end
          end

          if e = TechniqueInfo[:"#{count_all}段ロケット"] # 7段以上のロケットは除外する
            @analyzer.skill_push(e)
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

        if soldier.piece.key == :rook
          @rook_count += 1
          @rook = soldier.place
        else
          @lance_count += 1
          @lance = soldier.place
        end

        # 打った位置から上下に移動して飛車と香車の位置と個数を調べる

        [:up, :down].each do |up|
          (1..).each do |y|
            v = soldier.relative_move_to(up, magnification: y)
            v or break # 盤面の外
            if s = @analyzer.board[v]
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
    end
  end
end
