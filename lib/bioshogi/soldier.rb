# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/soldier_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  class Soldier
    class << self
      def from_str(str, **attributes)
        if str.kind_of?(self)
          return str
        end

        md = str.match(/\A(?<location>[#{Location.triangles_str}])?(?<place>..)(?<piece>#{Piece.all_names.join("|")})\z/o)
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

    include SimpleModel

    attr_accessor :piece
    attr_accessor :promoted
    attr_accessor :location
    attr_accessor :place

    private_class_method :new

    def initialize(*)
      super

      raise MustNotHappen, "piece missing" unless piece
      raise MustNotHappen, "promoted is nil" if promoted.nil?
      raise MustNotHappen, "location missing" unless location
      raise MustNotHappen, "place missing" unless place
    end

    def attributes
      {piece: piece, promoted: promoted, place: place, location: location}
    end

    # 手合割などを調べる際に並び順で異なるオブジェクトと見なされないようにするためだけに用意したものなので何をキーにしてもよい。place は基本ユニークなのでこれで並べる
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

    def horizontal_flip
      self.class.create(piece: piece, promoted: promoted, place: place.horizontal_flip, location: location)
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
    def move_list(board, **options)
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

    # この駒の状態で board に置いても「二歩」いも「死に駒」にもならない？
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
        Dimension::Xplace.dimension - 1 - top_spaces
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
        Dimension::Yplace.dimension - 1 - place.x.value
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

    def name(**options)
      location.name + place.name + any_name(options)
    end

    def name_without_location(**options)
      place.name + any_name(options)
    end

    def any_name(**options)
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

    def inspect
      "<#{self.class.name} #{name.inspect}>"
    end
  end

  concern :HandShared do
    included do
      include SimpleModel
      attr_accessor :soldier

      private_class_method :new
    end

    class_methods do
      def create(*args)
        Bioshogi.run_counts["#{name}.#{__method__}"] += 1
        new(*args).freeze
      end
    end

    def sandbox_execute(mediator, &block)
      begin
        execute(mediator)
        Bioshogi.run_counts["sandbox_execute.execute"] += 1
        yield
      ensure
        revert(mediator)
        Bioshogi.run_counts["sandbox_execute.revert"] += 1
      end
    end

    def to_kif(*)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def inspect
      "<#{self}>"
    end

    def to_s(**options)
      to_kif(options)
    end

    def king_captured?
      respond_to?(:captured_soldier) && captured_soldier && captured_soldier.piece.key == :king
    end

    # 合法手か？
    # 指してみて自分に王手がかかってない状態なら合法手
    # 自分が何か指してみて→相手の駒を動かして自分の玉が取られる→非合法手
    #
    # DropHand, MoveHand 両方に必要
    # 王手をかけらている状態なら、打ってさえぎらないといけない
    # 王手をかけらている状態なら、動いてかわさないといけない
    # つまり両方チェックが必要
    # MoveHand だけにしてしまうと王手をかけられた状態で無駄な打をしてしまう(王手放置)
    # このとき相手の玉に対して王手していると局面が不正ということになる。激指でも同様のエラーになった。
    #
    # 1. 駒を動かしたことで王手になっていないこと
    # 2. 王手の状態を回避したこと
    # の両方チェックするので↓この一つでよい。
    #
    def legal_move?(mediator)
      sandbox_execute(mediator) do
        !mediator.player_at(soldier.location).mate_danger?
      end
    end
  end

  class DropHand
    include HandShared

    def initialize(*)
      super

      raise MustNotHappen, "打つと同時に成った" if soldier.promoted
    end

    def execute(mediator)
      player = mediator.player_at(soldier.location)
      player.piece_box.pick_out(soldier.piece)
      mediator.board.place_on(soldier)
    end

    def revert(mediator)
      mediator.board.safe_delete_on(soldier.place)
      player = mediator.player_at(soldier.location)
      player.piece_box.add(soldier.piece.key => 1)
    end

    def to_kif(**options)
      options = {
        with_location: true,
      }.merge(options)

      if options[:with_location]
        s = soldier.name(options)
      else
        s = soldier.name_without_location(options)
      end
      s + "打"
    end

    def to_csa(**options)
      [
        soldier.location.csa_sign,
        "00",
        soldier.place.hankaku_number,
        soldier.to_csa,
      ].join
    end

    def to_sfen(**options)
      [
        soldier.piece.to_sfen,
        "*",
        soldier.place.to_sfen,
      ].join
    end

    # def legal_move?(mediator)
    #   true
    # end
  end

  class MoveHand
    include HandShared

    attr_accessor :origin_soldier
    attr_accessor :captured_soldier

    def execute(mediator)
      if captured_soldier
        mediator.board.safe_delete_on(soldier.place)
        player = mediator.player_at(soldier.location)
        player.piece_box.add(captured_soldier.piece.key => 1)
      end
      mediator.board.pick_up(origin_soldier.place)
      mediator.board.place_on(soldier)
    end

    def revert(mediator)
      mediator.board.pick_up(soldier.place)
      mediator.board.place_on(origin_soldier)

      if captured_soldier
        player = mediator.player_at(soldier.location)
        player.piece_box.pick_out(captured_soldier.piece)
        mediator.board.place_on(captured_soldier)
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
        soldier.place.name,
        origin_soldier.any_name(options),
        promote_trigger? ? "成" : "",
        "(", origin_soldier.place.hankaku_number, ")",
      ].join
    end

    def to_csa(**options)
      [
        soldier.location.csa_sign,
        origin_soldier.place.hankaku_number,
        soldier.place.hankaku_number,
        soldier.to_csa,
      ].join
    end

    def to_sfen(**options)
      [
        origin_soldier.place.to_sfen,
        soldier.place.to_sfen,
        promote_trigger? ? "+" : nil,
      ].join
    end

    # def legal_move2?(mediator)
    #
    #   # もし王手を掛けられているなら
    #   if mediator.player_at(soldier.location).mate_danger?
    #     sandbox_execute(mediator) do
    #       !mediator.player_at(soldier.location).mate_danger?
    #     end
    #   else
    #     # 自滅しないこと
    #     sandbox_execute(mediator) do
    #       !mediator.player_at(soldier.location).mate_danger?
    #     end
    #   end
    # end

    private

    # def hunari
    #     if promote_trigger?
    #       s << piece.name
    #       s << motion
    #       s << "成"
    #     else
    #       s << soldier.any_name
    #       s << motion
    #       if place_from && place_to                # 移動した and
    #         if place_from.promotable?(location) || # 移動元が相手の相手陣地 or
    #             place_to.promotable?(location)     # 移動元が相手の相手陣地
    #           unless promoted                      # 成ってない and
    #             if piece.promotable?               # 成駒になれる
    #               s << "不成" # or "生"
    #             end
    #           end
    #         end
    #       end
    #     end

  end
end
