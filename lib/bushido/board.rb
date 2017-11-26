# -*- frozen-string-literal: true -*-
#
# 盤面
#   board = Board.new
#   board["５五"] # => nil
#
module Bushido
  class Board
    attr_reader :surface

    class << self
      # 一時的に盤面のサイズを変更する(テスト用)
      #
      #   before do
      #     @size_save = Board.size_change([3, 5])
      #   end
      #   after do
      #     Board.size_change(@size_save)
      #   end
      #
      def size_change(size, &block)
        size_save = [Position::Hpos.size, Position::Vpos.size]
        Position::Hpos.size, Position::Vpos.size = size
        if block_given?
          begin
            yield
          ensure
            Position::Hpos.size, Position::Vpos.size = size_save
          end
        end
        size_save
      end

      # サイズ毎のクラスがいるかも
      # かなりやっつけの仮
      def size_type
        key = [Position::Hpos.size, Position::Vpos.size]
        {
          [5, 5] => :x55,
          [9, 9] => :x99,
        }[key]
      end

      # 一時的に成れない状況にする
      def disable_promotable
        begin
          _promotable_size = Position::Vpos._promotable_size
          Position::Vpos._promotable_size = nil
          yield
        ensure
          Position::Vpos._promotable_size = _promotable_size
        end
      end
    end

    def initialize
      @surface = {}
    end

    # 破壊的
    concerning :UpdateMethods do
      # 指定座標に駒を置く
      #   board.put_on("５五", soldier)
      def put_on(point, soldier)
        assert_board_cell_is_blank(point)
        raise MustNotHappen if soldier.point != point
        # soldier.point = point
        # set(point, soldier)
        @surface[Point[point].to_xy] = soldier # TODO: Point オブジェクトのままセットすることはできないか？
      end

      # 指定座標にある駒をを広い上げる
      def pick_up!(point)
        soldier = @surface.delete(point.to_xy)
        unless soldier
          raise NotFoundOnBoard, "#{point.name.inspect} の位置には何もありません"
        end
        soldier.point = nil
        soldier
      end

      # 駒をすべて削除する
      def abone_all
        @surface.values.find_all { |e| e.kind_of?(Soldier) }.each(&:abone)
      end

      # 指定のセルを削除する
      # プレイヤー側の soldiers からは削除しないので注意
      def abone_on(point)
        @surface.delete(point.to_xy)
      end
    end

    concerning :ReaderMethods do
      # 盤面の指定座標の取得
      #   board.lookup["５五"] # => nil
      def lookup(point)
        @surface[Point[point].to_xy]
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
        Position::Vpos.size.times.collect { |y|
          lookup(Point[[x, y]])
        }.compact
      end

      def to_s_soldiers
        @surface.values.collect(&:formal_name).sort.join(" ")
      end

      def to_s_soldiers2
        @surface.values.collect(&:mark_with_formal_name).sort.join(" ")
      end

      def to_s_kakiki
        KakikiFormat.new(self).to_s
      end

      def to_csa
        CsaBoardFormat.new(self).to_s
      end

      def to_s
        to_s_kakiki
      end
    end

    private

    # 盤上の指定座標に駒があるならエラーとする
    def assert_board_cell_is_blank(point)
      soldier = lookup(point)
      if soldier
        raise PieceAlredyExist, "#{point.name}にはすでに#{soldier}があります\n#{self}"
      end
    end

    concerning :TeaiMethods do
      # 後手が平手であることが条件
      def teai_name
        if teai_name_by_location(:white) == "平手"
          teai_name_by_location(:black)
        end
      end

      private

      # location 側の手合割を文字列で得る
      def teai_name_by_location(location)
        teai_info_by_location(location)&.name
      end

      # location 側の手合割を得る
      def teai_info_by_location(location)
        location = Location[location]

        # 手合割情報はすべて先手のデータなので、先手側から見た状態に揃える
        mini_soldiers = @surface.values.collect { |e|
          if e.player.location.key == location.key
            e.to_mini_soldier.merge(point: e.point.reverse_if_white_location(location), location: Location[:black])
          end
        }.compact.sort

        # p mini_soldiers.first
        # p TeaiInfo.first.black_mini_soldiers.first

        TeaiInfo.find do |e|
          e.black_mini_soldiers == mini_soldiers
        end
      end
    end
  end
end
