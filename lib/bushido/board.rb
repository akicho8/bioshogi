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

    # 縦列の盤上のすべての駒
    def pieces_of_vline(x)
      Position::Vpos.size.times.collect { |y|
        fetch(Point.parse([x, y]))
      }.compact
    end

    # 指定座標に駒を置く
    #   board.put_on("５五", soldier)
    def put_on(point, soldier)
      assert_board_cell_is_blank(point)
      # assert_not_double_pawn(player, point, piece)

      soldier.point = point
      # soldier.double_pawn_validation(self, point)

      set(point, soldier)
    end

    # 指定座標に何かを置く
    def set(point, object)
      @surface[Point[point].to_xy] = object
    end

    # fetchのエイリアス
    #   board["５五"] # => nil
    def [](point)
      fetch(point)
    end

    # 盤面の指定座標の取得
    #   board.fetch["５五"] # => nil
    def fetch(point)
      @surface[Point.parse(point).to_xy]
    end

    # 指定座標にある駒をを広い上げる
    def pick_up!(point)
      soldier = @surface.delete(point.to_xy)
      soldier or raise NotFoundOnBoard, "#{point.name}の位置には何もない"
      soldier.point = nil
      soldier
    end

    # 盤面表示
    #   to_s
    #   to_s(:debug)
    #   to_s(:kakiki)
    def to_s(format = :default)
      send("to_s_#{format}")
    end

    # 空いている場所のリスト
    def blank_points
      Point.find_all { |point| !fetch(point) }
    end

    # 置いてる駒リスト
    def to_s_soldiers
      @surface.values.collect(&:to_s_formal_name).sort.join(" ")
    end
    def to_s_soldiers2
      @surface.values.collect(&:mark_with_formal_name).sort.join(" ")
    end

    # 駒をすべて削除する
    def abone_all
      @surface.values.find_all { |e| e.kind_of?(Soldier) }.each(&:abone)
    end

    # 指定のセルを削除する
    # プレイヤー側の soldiers からは削除しないので注意
    def __abone_cell(value)
      if value.kind_of?(Point)
        value = value.to_xy
      end
      @surface.delete(value)
    end

    def to_s_kakiki
      KakikiFormat.new(self).to_s
    end

    private

    # 盤面の文字列化
    def to_s_default
      to_s(:kakiki)
    end

    # 盤面の文字列化(開発用なので好きなフォーマットでいい)
    def to_s_debug
      rows = Position::Vpos.size.times.collect do |y|
        Position::Hpos.size.times.collect do |x|
          @surface[[x, y]]
        end
      end
      rows = rows.zip(Position::Vpos.units).collect { |e, u|
        e + [u]
      }
      RainTable::TableFormatter.format(Position::Hpos.units + [""], rows, header: true)
    end

    # 盤上の指定座標に駒があるならエラーとする
    def assert_board_cell_is_blank(point)
      object = fetch(point)
      if object
        # if Soldier === object
        # end
        raise PieceAlredyExist, "#{point.name}にはすでに#{object}がある\n#{self}"
      end
    end
  end
end
