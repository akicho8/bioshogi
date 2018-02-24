# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/soldier_spec.rb" -*-
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

      def piece_and_promoted(object)
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
        create(piece_and_promoted(object).merge(attributes))
      end

      def preset_one_side_soldiers(preset_key, location: :black)
        location = Location[location]
        PresetInfo.fetch(preset_key).board_parser.location_adjust[location.key]
      end

      def preset_soldiers(**params)
        Location.flat_map do |location|
          PresetInfo.fetch(params[location.key] || :"平手").board_parser.location_adjust[location.key]
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

      raise MustNotHappen, "piece is nil" if piece.nil?
      raise MustNotHappen, "promoted is nil" if promoted.nil?
      raise MustNotHappen, "location missing" unless location
      raise MustNotHappen, "point missing" unless point
    end

    def attributes
      {piece: piece, promoted: promoted, point: point, location: location}
    end

    # 手合割などを調べる際に並び順で異なるオブジェクトと見なされないようにするためだけに用意したものなので何をキーにしてもよい。point は基本ユニークなのでこれで並べる
    def <=>(other)
      point <=> other.point
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      self.class == other.class && attributes == other.attributes
    end

    def hash
      attributes.hash
    end

    def flip
      self.class.create(piece: piece, promoted: promoted, point: point.flip, location: location.flip)
    end

    def flip_if_white
      if location.key == :white
        flip
      else
        self
      end
    end

    def all_vectors
      piece.all_vectors(promoted: promoted, location: location)
    end

    # 1. 常に生きている
    # 2. 成り(=絶対に死に駒ならない)
    # の順で先にチェックすることで高速化
    def alive?
      piece.always_alive || promoted || all_vectors.any? { |e| point.vector_add(e).valid? }
    end

    def merge(attributes)
      self.class.create(self.attributes.merge(attributes))
    end

    ################################################################################ Utility

    # 自分を移動元の状態と考えて to に移動したとき成れるか？
    def next_promotable?(to)
      piece.promotable? && !promoted && (point.promotable?(location) || to.promotable?(location))
    end

    # 移動可能な座標を取得
    def move_list(board, **options)
      Movabler.move_list(board, self, options)
    end

    # 二歩？
    def collision_pawn(board)
      if piece.key == :pawn && !promoted
        board.vertical_pieces(point.x).find do |e|
          e.piece.key == :pawn && !e.promoted && e.location == location
        end
      end
    end

    # この駒の状態で board に置いても「二歩」いも「死に駒」にもならない？
    def rule_valid?(board)
      !collision_pawn(board) && alive?
    end

    ################################################################################ Formatter

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
      piece.csa.any_name(promoted)
    end

    def inspect
      "<#{self.class.name} #{name.inspect}>"
    end
  end

  concern :HandShared do
    included do
      include ActiveModel::Model
      attr_accessor :soldier

      private_class_method :new
    end

    class_methods do
      def create(*args)
        Warabi.exec_counts["#{name}.#{__method__}"] += 1
        new(*args).freeze
      end
    end

    def to_kif(*)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def inspect
      "#<#{self}>"
    end

    def to_s(**options)
      to_kif(options)
    end
  end

  class DirectHand
    include HandShared

    def initialize(*)
      super

      raise MustNotHappen, "打つと同時に成った" if soldier.promoted
    end

    def execute(mediator)
      player = mediator.player_at(soldier.location)
      player.piece_box.pick_out(soldier.piece)
      mediator.board.put_on(soldier)
    end

    def revert(mediator)
      mediator.board.safe_delete_on(soldier.point)
      player = mediator.player_at(soldier.location)
      player.piece_box.add(soldier.piece.key => 1)
    end

    def to_kif(**options)
      options = {
        with_location: true,
      }.merge(options)

      if options[:with_location]
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

  class MoveHand
    include HandShared

    attr_accessor :origin_soldier
    attr_accessor :killed_soldier

    def execute(mediator)
      if killed_soldier
        mediator.board.safe_delete_on(soldier.point)
        player = mediator.player_at(soldier.location)
        player.piece_box.add(killed_soldier.piece.key => 1)
      end
      mediator.board.pick_up(origin_soldier.point)
      mediator.board.put_on(soldier)
    end

    def revert(mediator)
      mediator.board.pick_up(soldier.point)
      mediator.board.put_on(origin_soldier)

      if killed_soldier
        player = mediator.player_at(soldier.location)
        player.piece_box.pick_out(killed_soldier.piece)
        mediator.board.put_on(killed_soldier)
      end
    end

    def promote_trigger?
      !origin_soldier.promoted && soldier.promoted
    end

    def to_kif(**options)
      options = {
        with_location: true,
      }.merge(options)

      [
        options[:with_location] ? soldier.location.name : nil,
        soldier.point.name,
        origin_soldier.any_name,
        promote_trigger? ? "成" : "",
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
        promote_trigger? ? "+" : nil,
      ].join
    end
  end
end
