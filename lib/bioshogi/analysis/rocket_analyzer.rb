# frozen-string-literal: true

module Bioshogi
  module Analysis
    class RocketAnalyzer
      DEBUG = false

      attr_reader :analyzer
      attr_reader :soldier
      attr_reader :drop_hand

      delegate :executor, to: :analyzer

      def initialize(analyzer)
        @analyzer = analyzer
      end

      def call
        unless corresponding_piece?
          return
        end

        investigate
        count = @rook_count + @lance_count

        # 「飛龍香」が縦に1つしかないので除外する
        if count <= 1
          return
        end

        # 「飛飛」並びは除外する
        if @rook_count == 2 && @lance_count == 0
          return
        end

        # 飛の下に香がある形は除外する
        # [@lance_y, @rook_y, @lance_y <=> @rook_y, soldier.location.value_sign] # => [3, 4, -1, 1] (先手)
        # [@lance_y, @rook_y, @lance_y <=> @rook_y, soldier.location.value_sign] # => [5, 4, 1, -1] (後手)
        # つまり ((@lance_y <=> @rook_y) + soldier.location.value_sign).zero? のとき飛車の上に香車がいる
        if @rook_count == 1 && @lance_count == 1
          if ((@lance_y <=> @rook_y) + soldier.location.value_sign).nonzero?
            return
          end
        end

        if count >= 2
          # analyzer.skill_push(NoteInfo[:"ロケット"])
          if technique_info = TechniqueInfo[:"#{count}段ロケット"] # 7段以上のロケットは除外する
            analyzer.skill_push(technique_info)
          end
        end
      end

      private

      def investigate
        @rook_y  = nil          # 飛車のY座標
        @lance_y = nil          # 香車のY座標

        @rook_count  = 0        # 発見した飛車の個数
        @lance_count = 0        # 発見した香車の個数

        # いま打った駒が飛車か香車かで初期値を調整する

        if soldier.piece.key == :rook
          @rook_count += 1
          @rook_y = soldier.place.y.value
        else
          @lance_count += 1
          @lance_y = soldier.place.y.value
        end

        # 打った位置から上下に移動して飛車と香車の位置と個数を調べる

        [-1, 1].each do |sign| # -1:↑ 1:↓
          (1..).each do |y|
            place = Place.lookup([soldier.place.x.value, soldier.place.y.value + (y * soldier.location.value_sign * sign)])
            unless place
              break                                     # 盤面の外
            end
            if s = analyzer.surface[place]
              if s.location != soldier.location
                break                                   # 相手の駒
              end
              case
              when s.piece.key == :rook                 # 「飛」「龍」
                @rook_count += 1
                @rook_y = place.y.value
              when s.piece.key == :lance && !s.promoted # 「香」
                @lance_count += 1
                @lance_y = place.y.value
              else
                break                                   # 自分の「飛龍香」以外
              end
            end
          end
        end
      end

      def corresponding_piece?
        soldier.piece.key == :rook || (soldier.piece.key == :lance && !soldier.promoted && drop_hand)
      end

      def surface
        analyzer.surface
      end

      def soldier
        executor.hand.soldier
      end

      def drop_hand
        executor.drop_hand
      end
    end
  end
end
