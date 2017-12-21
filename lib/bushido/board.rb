# frozen-string-literal: true
#
# 盤面
#   board = Board.new
#   board["５五"] # => nil
#
module Bushido
  class Board
    attr_reader :surface

    class << self
      delegate :size_change, :size_type, :disable_promotable, :to => "Bushido::Position"
    end

    def initialize
      @surface = {}
    end

    # 破壊的
    concerning :UpdateMethods do
      # 指定座標に駒を置く
      #   board.put_on("５五", battler)
      def put_on(point, battler)
        assert_board_cell_is_blank(point)
        raise MustNotHappen if battler.point != point
        # battler.point = point
        # set(point, battler)
        point = Point.fetch(point)
        @surface[point] = battler # TODO: Point オブジェクトのままセットすることはできないか？
      end

      # 指定座標にある駒をを広い上げる
      def pick_up!(point)
        battler = @surface.delete(point)
        unless battler
          raise NotFoundOnBoard, "#{point.name.inspect} の位置には何もありません"
        end
        battler.point = nil
        battler
      end

      # 駒をすべて削除する
      def abone_all
        @surface.values.find_all { |e| e.kind_of?(Battler) }.each(&:abone)
      end

      # 指定のセルを削除する
      # プレイヤー側の battlers からは削除しないので注意
      def abone_on(point)
        @surface.delete(point)
      end

      private

      # 盤上の指定座標に駒があるならエラーとする
      def assert_board_cell_is_blank(point)
        battler = lookup(point)
        if battler
          raise PieceAlredyExist, "#{point.name}にはすでに#{battler}があります\n#{self}"
        end
      end
    end

    concerning :ReaderMethods do
      # 盤面の指定座標の取得
      #   board.lookup["５五"] # => nil
      def lookup(point)
        point = Point.fetch(point)
        @surface[point]
      end

      # lookupのエイリアス
      #   board["５五"] # => nil
      def [](point)
        lookup(point)
      end

      # 空いている場所のリスト
      def blank_points
        Point.find_all { |point| !lookup(point) }
      end

      # X列の駒たち
      def vertical_pieces(x)
        Position::Vpos.board_size.times.collect { |y|
          lookup([x, y])
        }.compact
      end

      def to_s_battlers
        @surface.values.collect(&:formal_name).sort.join(" ")
      end

      def to_s_battlers2
        @surface.values.collect(&:mark_with_formal_name).sort.join(" ")
      end

      def to_kif
        KakikiFormat.new(self).to_s
      end

      def to_ki2
        to_kif
      end

      def to_csa
        CsaBoardFormat.new(self).to_s
      end

      def to_s
        to_kif
      end

      def to_sfen
        Position::Vpos.board_size.times.collect { |y|
          Position::Hpos.board_size.times.collect { |x|
            point = Point.fetch([x, y])
            @surface[point]
          }.chunk(&:class).flat_map { |klass, e|
            if klass == NilClass
              e.count
            else
              e.collect(&:to_sfen)
            end
          }.join
        }.join("/")
      end
    end

    concerning :TeaiwariMethods do
      # ▲が平手であることが条件
      def teaiwari_name
        if teaiwari_name_by_location(:black) == "平手"
          teaiwari_name_by_location(:white)
        end
      end

      private

      # location 側の手合割を文字列で得る
      def teaiwari_name_by_location(location)
        if v = teaiwari_info_by_location(location)
          v.name
        end
      end

      # location 側の手合割情報を得る
      def teaiwari_info_by_location(location)
        # 駒配置情報は9x9を想定しているため9x9ではないときは手合割に触れないようにする
        # これがないと、board_spec.rb だけを実行したとき落ちる
        if Position.size_type != :board_size_9x9
          return
        end

        location = Location[location]

        # 手合割情報はすべて先手のデータなので、先手側から見た状態に揃える
        sorted_black_side_soldiers = @surface.values.collect { |e|
          if e.location == location
            e.to_soldier.reverse_if_white
          end
        }.compact.sort

        TeaiwariInfo.find do |e|
          e.sorted_black_side_soldiers == sorted_black_side_soldiers
        end
      end
    end
  end
end
