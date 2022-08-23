# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/soldier_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  class Soldier
    class << self
      def from_str(str, attributes = {})
        if str.kind_of?(self)
          return str
        end

        md = str.match(/\A(?<location>[#{Location.polygon_chars_str}])?(?<place>..)(?<piece>#{Piece.all_names.join("|")})\z/o)
        md or raise SyntaxDefact, "表記が間違っています。'６八銀' や '68銀' のように1つだけ入力してください : #{str.inspect}"

        location = nil
        if v = md[:location]
          location = Location[v]
        end
        if v = attributes[:location]
          location = Location[v]
        end
        attrs = {place: Place.fetch(md[:place]), location: location}
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
        { piece: piece, promoted: promoted }
      end

      def new_with_promoted(object, attributes = {})
        create(piece_and_promoted(object).merge(attributes))
      end

      def preset_one_side_soldiers(preset_key, location: :black)
        location = Location[location]
        PresetInfo.fetch(preset_key).board_parser.location_adjust[location.key]
      end

      # 先後それぞれの形を指定する
      # Soldier.preset_soldiers(white: "裸玉", black: "裸玉").collect(&:name) # => ["▲５九玉", "△５一玉"]
      def preset_soldiers(preset_key)
        PresetInfo.fetch(preset_key || :"平手").sorted_soldiers
      end

      def create(*args)
        new(*args).freeze
      end
    end

    include SimpleModel

    attr_accessor :piece
    attr_accessor :promoted
    attr_accessor :location
    attr_accessor :place

    private_class_method :new

    def initialize(*)
      super

      Assertion.assert { piece          }
      Assertion.assert { !promoted.nil? }
      Assertion.assert { location       }
      Assertion.assert { place          }
    end

    def attributes
      { piece: piece, promoted: promoted, place: place, location: location }
    end

    # 手合割などを調べる際に並び順で異なるオブジェクトと見なされないようにするためだけに用意した
    # だから何をキーにしてもよい。place は基本ユニークなのでこれで並べる
    def <=>(other)
      place <=> other.place
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
      self.class.create(piece: piece, promoted: promoted, place: place.flip, location: location.flip)
    end

    def flop
      self.class.create(piece: piece, promoted: promoted, place: place.flop, location: location)
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

    # 死に駒ではない？
    def alive?
      v = false
      v ||= piece.always_alive # 死に駒にならない駒か？ (基本、後ろに移動できる駒)
      v ||= promoted           # すでに成っているか？ (成っている駒は金の動きなので後ろに移動できる)
      v ||= all_vectors.any? { |e| place.vector_add(e).valid? } # ちょっとでも動ける？
    end

    def merge(attributes)
      self.class.create(self.attributes.merge(attributes))
    end

    ################################################################################ Utility

    # 自分を移動元の状態と考えて to に移動したとき成れるか？
    def next_promotable?(to)
      piece.promotable? && !promoted && (place.promotable?(location) || to.promotable?(location))
    end

    # 移動可能な座標を取得
    def move_list(board, options = {})
      Movabler.move_list(board, self, options)
    end

    # 二歩？
    def collision_pawn(board)
      if piece.key == :pawn && !promoted
        board.vertical_pieces(place.x).find do |e|
          e.piece.key == :pawn && !e.promoted && e.location == location
        end
      end
    end

    # いまの状態で board に置いたとき「二歩」にも「死に駒」にもならないか？
    def rule_valid?(board)
      !collision_pawn(board) && alive?
    end

    # 自分を▲側に補正したときの座標
    def normalized_place
      place.flip_if_white(location)
    end

    # 手筋判定用
    concerning :TechniqueMatcherMethods do
      # 自分の側の一番下を0としてどれだけ前に進んでいるかを返す
      def bottom_spaces
        Dimension::Yplace.dimension - 1 - top_spaces
      end

      # 自分の側の一番上を0としてあとどれだけで突き当たるかの値
      def top_spaces
        place.flip_if_white(location).y.value
      end

      # 「左右の壁からどれだけ離れているかの値」の小さい方(先後関係なし)
      def smaller_one_of_side_spaces
        [place.x.value, __distance_from_right].min
      end

      # 左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)
      def sign_to_goto_closer_side
        if place.x.value > __distance_from_right
          1
        else
          -1
        end
      end

      # 先手から見て右からの距離
      def __distance_from_right
        Dimension::Xplace.dimension - 1 - place.x.value
      end

      # センターにいる？
      def center_place?
        place.x.value == Dimension::Xplace.dimension / 2
      end

      # 自玉の位置にいる？
      def initial_place?
        center_place? && bottom_spaces == 0
      end

      # 駒の重さ(=価値) 常にプラス
      def abs_weight
        piece.any_weight(promoted)
      end

      # 駒の重さ(=価値)。先手視点。後手ならマイナスになる
      def relative_weight
        abs_weight * location.value_sign
      end

      # 敵への駒の圧力(終盤度)
      def pressure_level(area = 4)
        case
        when top_spaces < area
          if promoted
            piece.promoted_attack_level
          else
            piece.attack_level
          end
        when bottom_spaces < area
          if promoted
            -piece.promoted_defense_level
          else
            -piece.defense_level
          end
        else
          0
        end
      end
    end

    ################################################################################ Formatter

    def to_s
      name
    end

    def name(options = {})
      location.name + place.name + any_name(options)
    end

    def name_without_location(options = {})
      place.name + any_name(options)
    end

    def any_name(options = {})
      piece.any_name(promoted, options)
    end

    def yomiage
      piece.yomiage(promoted)
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

    def to_akf
      {
        :piece    => piece.key,
        :promoted => promoted,
        :place    => place.to_human_h,
        :location => location.key,
      }
    end

    def inspect
      "<#{self.class.name} #{name.inspect}>"
    end
  end
end
