# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/soldier_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Soldier
    class << self
      def from_str(str, **attributes)
        if str.kind_of?(self)
          return str
        end

        md = str.match(/\A(?<location>[#{Location.triangles_str}])?(?<point>..)(?<piece>#{Piece.all_names.join("|")})\z/o)
        md or raise SyntaxDefact, "表記が間違っています。'６八銀' や '68銀' のように1つだけ入力してください : #{str.inspect}"

        location = nil
        if v = md[:location]
          location = Location[v]
        end
        if v = attributes[:location]
          location = Location[v]
        end
        attrs = {point: Point.fetch(md[:point]), location: location}
        new_with_promoted(md[:piece], attrs)
      end

      def new_with_promoted_attributes(object)
        case
        when piece = Piece.basic_group[object]
          promoted = false
        when piece = Piece.promoted_group[object]
          promoted = true
        else
          raise PieceNotFound, "#{object.inspect} に対応する駒がありません"
        end
        {piece: piece, promoted: promoted}
      end

      def new_with_promoted(object, **attributes)
        create(new_with_promoted_attributes(object).merge(attributes))
      end

      def preset_one_side_soldiers(preset_key, location: :black)
        location = Location[location]
        PresetInfo.fetch(preset_key).board_parser.location_adjust[location.key]
      end

      def preset_soldiers(**params)
        params = {
          black: "平手",
          white: "平手",
        }.merge(params)

        Location.flat_map do |location|
          PresetInfo.fetch(params[location.key]).board_parser.location_adjust[location.key]
        end
      end

      def create(*args)
        new(*args).freeze
      end
    end

    include ActiveModel::Model

    attr_accessor :piece
    attr_accessor :promoted
    attr_accessor :point
    attr_accessor :location

    private_class_method :new

    def initialize(*)
      super

      raise WarabiError, "piece is nil" if piece.nil?
      raise WarabiError, "promoted is nil" if promoted.nil?
      raise WarabiError, "location missing" unless location
      raise WarabiError, "point missing" unless point
    end

    def attributes
      {piece: piece, promoted: promoted, point: point, location: location}
    end

    # def to_soldier
    #   Soldier.create(soldier_attributes)
    # end

    # soldiers.sort できるようにする
    # 手合割などを調べる際に並び順で異なるオブジェクトと見なされないようにするためだけに用意したものなので何をキーにしてもよい
    def <=>(other)
      point <=> other.point
    end

    def reverse
      self.class.create(piece: piece, promoted: promoted, point: point.reverse, location: location.reverse)
    end

    def reverse_if_white
      if location.key == :white
        reverse
      else
        self
      end
    end

    def all_vectors
      piece.all_vectors(promoted: promoted, location: location)
    end

    def alive?
      all_vectors.any? { |e| point.vector_add(e).valid? }
    end

    def merge(attributes)
      self.class.create(self.attributes.merge(attributes))
    end

    def eql?(other)
      raise MustNotHappen if self.class != other.class
      attributes == other.attributes
    end

    def hash
      attributes.hash
    end

    def ==(other)
      eql?(other)
    end

    # 移動可能な座標を取得
    def moved_list(board)
      Movabler.moved_list(board, self)
    end

    # 現状の状態から成れるか？
    # 相手陣地から出たときのことは考慮しなくてよい
    # そもそも移動元をこのインスタンスは知らない
    def next_promotable?
      true &&
        piece.promotable? &&           # 成ることができる駒の種類かつ
        !promoted &&                   # まだ成っていないかつ
        point.promotable?(location) && # 現在地点は相手の陣地内か？
        true
    end

    ################################################################################ Reader

    def to_s
      name
    end

    def name
      location.name + point.name + any_name
    end

    def name_without_location
      point.name + any_name
    end

    def any_name
      piece.any_name(promoted)
    end

    def to_bod
      location.varrow + any_name
    end

    def to_sfen
      piece.to_sfen(promoted: promoted, location: location)
    end

    def to_csa_bod
      location.csa_sign + to_csa
    end

    def to_csa
      piece.csa_some_name(promoted)
    end

    def inspect
      "<#{self.class.name} #{name.inspect}>"
    end
  end

  class Direct
    concerning :Shared do
      included do
        include ActiveModel::Model
        attr_accessor :soldier

        private_class_method :new
      end

      class_methods do
        def create(*args)
          new(*args).freeze
        end
      end

      def to_kif(*)
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end

    def initialize(*)
      super

      raise MustNotHappen, "打つと同時に成った" if soldier.promoted
    end

    def to_kif(**options)
      options = {
        with_mark: true,
      }.merge(options)

      if options[:with_mark]
        s = soldier.name
      else
        s = soldier.name_without_location
      end
      s + "打"
    end

    def to_csa(**options)
      [
        soldier.location.csa_sign,
        "00",
        soldier.point.number_format,
        soldier.to_csa,
      ].join
    end

    def to_sfen(**options)
      [
        soldier.piece.to_sfen,
        "*",
        soldier.point.to_sfen,
      ].join
    end
  end

  class Moved
    include Direct::Shared

    attr_accessor :origin_soldier

    def promote_trigger
      !origin_soldier.promoted && soldier.promoted
    end

    def to_kif(**options)
      options = {
        with_mark: true,
      }.merge(options)

      [
        options[:with_mark] ? soldier.location.name : nil,
        soldier.point.name,
        origin_soldier.any_name,
        promote_trigger ? "成" : "",
        "(", origin_soldier.point.number_format, ")",
      ].join
    end

    def to_csa(**options)
      [
        soldier.location.csa_sign,
        origin_soldier.point.number_format,
        soldier.point.number_format,
        soldier.to_csa,
      ].join
    end

    def to_sfen(**options)
      [
        origin_soldier.point.to_sfen,
        soldier.point.to_sfen,
        promote_trigger ? "+" : nil,
      ].join
    end
  end
end
