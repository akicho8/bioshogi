# frozen-string-literal: true

require_relative "board_piller_methods"
require_relative "board_piece_counts_methods"

module Bioshogi
  class Board
    class << self
      delegate :dimensiton_change, :size_type, :promotable_disable, to: "Bioshogi::Dimension"

      # 指定の柿木図面から手合割を逆算する
      def guess_preset_info(shape, options = {})
        board = new
        board.placement_from_shape(shape)
        board.preset_info(options)
      end

      def create_by_shape(key)
        new.tap do |board|
          board.placement_from_shape(key)
        end
      end

      def create_by_human(key)
        new.tap do |board|
          board.placement_from_human(key)
        end
      end

      def create_by_preset(key)
        new.tap do |board|
          board.placement_from_preset(key)
        end
      end
    end

    delegate :hash, to: :surface

    def surface
      @surface ||= {}
    end

    concerning :UpdateMethods do
      def place_on(soldier, options = {})
        options = {
          validate: false,
        }.merge(options)

        if options[:validate]
          assert_cell_blank(soldier.place)
        end

        surface[soldier.place] = soldier
      end

      def pick_up(place)
        soldier = safe_delete_on(place)
        unless soldier
          raise NotFoundOnBoard, "#{place}の位置には何もありません"
        end
        soldier
      end

      def safe_delete_on(place)
        surface.delete(place)
      end

      def all_clear
        surface.clear
      end

      # for DSL
      # 引数の種類がわかっているなら専用メソッドを使うべき
      def placement_from_any(v)
        case
        when PresetInfo.lookup(v)
          placement_from_preset(v)
        when BoardParser.accept?(v)
          placement_from_shape(v)
        when v.kind_of?(String) && !InputParser.scan(v).empty?
          placement_from_human(v)
        else
          raise ArgumentError, v.inspect
        end
      end

      # 手合割で設定
      def placement_from_preset(preset_key)
        placement_from_soldiers(Soldier.preset_soldiers(preset_key))
      end

      # 柿木盤を読み取って反映する
      # 毎回読み取るため遅い
      def placement_from_shape(str)
        placement_from_soldiers(BoardParser.parse(str).soldier_box)
      end

      # 詰将棋の配置の読み上げのような表記で盤に反映する
      # placement_from_human("△51玉 ▲59玉")
      def placement_from_human(str)
        soldiers = InputParser.scan(str).collect { |s| Soldier.from_str(s) }
        placement_from_soldiers(soldiers)
      end

      # まとめて追加で置く
      def placement_from_soldiers(soldiers)
        soldiers.each { |e| place_on(e) }
      end

      private

      def assert_cell_blank(place)
        if surface.has_key?(place)
          raise PieceAlredyExist, "空のはずの#{place}に駒があります\n#{self}"
        end
      end
    end

    concerning :ReaderMethods do
      def lookup(place)
        surface[Place.fetch(place)]
      end

      def [](place)
        lookup(place)
      end

      def fetch(place)
        lookup(place) or raise PieceNotFoundOnBoard, "#{place}に何もありません\n#{self}"
      end

      # FIXME: 空いている升の情報は駒を動かした時点で更新するようにすればこの部分の無駄な判定を減らせる
      def blank_places
        Enumerator.new do |y|
          Place.each do |place|
            unless surface[place]
              y << place
            end
          end
        end
      end

      def vertical_pieces(x)
        Enumerator.new do |yielder|
          Dimension::Yplace.dimension.times do |y|
            if soldier = lookup([x, y])
              yielder << soldier
            end
          end
        end
      end

      # def move_list(soldier, options = {})
      #   Movabler.move_list(self, soldier, options)
      # end

      def soldiers
        surface.values
      end

      # 盤上に「歩」と「と」があるなら {p: 2} を返す
      def to_piece_box
        soldiers.inject(PieceBox.new) { |a, e| a.merge(e.piece.key => 1) { |k, a, b| a + b } }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end

      # 盤の状態から手合割を逆算
      # バリケード将棋などは持駒も見る必要があるけどやってない
      def preset_info(options = {})
        PresetInfo.lookup_by_soldiers(surface.values, options)
      end

      def to_kif
        KakinokiBoardFormatter.new(self).to_s
      end

      def to_ki2
        to_kif
      end

      def to_csa
        CsaBoardFormatter.new(self).to_s
      end

      def to_s
        to_kif
      end

      def to_sfen
        Dimension::Yplace.dimension.times.collect { |y|
          Dimension::Xplace.dimension.times.collect { |x|
            lookup([x, y])
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

    concerning :TechniqueMatcherMethods do
      # 180度回転した盤面を返す
      def flip
        self.class.new.tap do |board|
          surface.values.each do |e|
            board.place_on(e.half_rotate)
          end
        end
      end

      # X軸のみを反転した盤面を返す
      def flop
        self.class.new.tap do |board|
          surface.values.each do |e|
            board.place_on(e.flop)
          end
        end
      end
    end

    prepend BoardPillerMethods
    prepend BoardPieceCountsMethods
  end
end
