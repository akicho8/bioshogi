# frozen-string-literal: true
#
# 盤面
#   board = Board.new
#   board["５五"] # => nil
#
module Warabi
  class Board
    attr_reader :surface

    class << self
      delegate :size_change, :size_type, :disable_promotable, to: "Warabi::Position"
    end

    def initialize
      @surface = {}
    end

    concerning :UpdateMethods do
      def put_on(soldier, **options)
        options = {
          validate_collision_pawn: false,
          validate_alive: false,
          validate: false,
        }.merge(options)

        if options[:validate] || options[:validate_alive]
          assert_alive(soldier)
        end

        if options[:validate] || options[:validate_collision_pawn]
          assert_not_collision_pawn(soldier)
        end

        assert_cell_blank(soldier.point)
        @surface[soldier.point] = soldier
      end

      # 指定座標にある駒をを広い上げる
      def pick_up!(point)
        soldier = @surface.delete(point)
        unless soldier
          raise NotFoundOnBoard, "#{point}の位置には何もありません"
        end
        soldier
      end

      # 駒をすべて削除する
      def all_clear
        @surface.clear
      end

      # 指定のセルを削除する
      def delete_on(point)
        @surface.delete(point)
      end

      private

      def assert_cell_blank(point)
        if soldier = lookup(point)
          raise PieceAlredyExist, "盤上にすでに#{soldier}があります\n#{self}"
        end
      end

      def assert_not_collision_pawn(soldier)
        if collision_soldier = soldier.collision_pawn(self)
          raise DoublePawnError, "二歩です。すでに#{collision_soldier}があるため#{soldier}が打てません\n#{self}"
        end
      end

      def assert_alive(soldier)
        if !soldier.alive?
          raise DeadPieceRuleError, "#{soldier}は死に駒です。「#{soldier}成」の間違いの可能性があります"
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
        Enumerator.new do |y|
          Point.each do |point|
            if !lookup(point)
              y << point
            end
          end
        end
      end

      # X列の駒たち
      def vertical_pieces(x)
        Enumerator.new do |yielder|
          Position::Vpos.dimension.times do |y|
            if soldier = lookup([x, y])
              yielder << soldier
            end
          end
        end
      end

      def moved_list(soldier)
        Movabler.moved_list(self, soldier)
      end

      def to_s_soldiers
        @surface.values.collect(&:name_without_location).sort.join(" ")
      end

      def to_kif
        KakikiBoardFormater.new(self).to_s
      end

      def to_ki2
        to_kif
      end

      def to_csa
        CsaBoardFormater.new(self).to_s
      end

      def to_s
        to_kif
      end

      def to_sfen
        Position::Vpos.dimension.times.collect { |y|
          Position::Hpos.dimension.times.collect { |x|
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

    concerning :PresetMethods do
      # ▲が平手であることが条件
      def preset_name
        if preset_name_by_location(:black) == "平手"
          preset_name_by_location(:white)
        end
      end

      private

      # location 側の手合割を文字列で得る
      def preset_name_by_location(location)
        if v = preset_info_by_location(location)
          v.name
        end
      end

      # location 側の手合割情報を得る
      def preset_info_by_location(location)
        # 駒配置情報は9x9を想定しているため9x9ではないときは手合割に触れないようにする
        # これがないと、board_spec.rb だけを実行したとき落ちる
        if Position.size_type != :board_size_9x9
          return
        end

        location = Location[location]

        # 手合割情報はすべて先手のデータなので、先手側から見た状態に揃える
        black_only_soldiers = @surface.values.collect { |e|
          if e.location == location
            e.flip_if_white
          end
        }.compact.sort

        PresetInfo.find do |e|
          e.location_split[:black] == black_only_soldiers
        end
      end
    end
  end
end
