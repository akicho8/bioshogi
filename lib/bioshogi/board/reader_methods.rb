module Bioshogi
  module Board
    module ReaderMethods
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
          Dimension::DimensionRow.dimension.times do |y|
            if soldier = lookup([x, y])
              yielder << soldier
            end
          end
        end
      end

      # def move_list(soldier, options = {})
      #   SoldierWalker.call(self, soldier, options)
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
        KakinokiFormatter.new(self).to_s
      end

      def to_ki2
        to_kif
      end

      def to_csa
        CsaFormatter.new(self).to_s
      end

      def to_s
        to_kif
      end

      def to_sfen
        Dimension::DimensionRow.dimension.times.collect { |y|
          Dimension::DimensionColumn.dimension.times.collect { |x|
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
  end
end
