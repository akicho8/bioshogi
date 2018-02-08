# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/soldier_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Soldier
    class << self
      def from_str(str)
        if str.kind_of?(self)
          return str
        end
        md = str.match(/\A(?<location>[#{Location.triangles_str}])?(?<point>..)(?<piece>#{Piece.all_names.join("|")})\z/o)
        md or raise SyntaxDefact, "表記が間違っています。'６八銀' や '68銀' のように1つだけ入力してください : #{str.inspect}"
        new_with_promoted(md[:piece], point: Point.fetch(md[:point]), location: Location[md[:location]])
      end

      def new_with_promoted(object, **attributes)
        case
        when piece = Piece.basic_group[object]
          promoted = false
        when piece = Piece.promoted_group[object]
          promoted = true
        else
          raise PieceNotFound, "#{object.inspect} に対応する駒がありません"
        end
        new({piece: piece, promoted: promoted}.merge(attributes)).freeze
      end

      # 指定プレイヤー側の初期配置(「角落ち」などを指定可)
      # @example
      #   Soldier.location_soldiers(location: :black, key: "平手")
      #   Soldier.location_soldiers(location: :black, key: "+---...")
      def location_soldiers(params)
        params = {
          location: nil,
          key: nil,
        }.merge(params)

        if BoardParser.accept?(params[:key])
          board_parser = BoardParser.parse(params[:key])
        else
          board_parser = PresetInfo.fetch(params[:key]).board_parser
        end

        soldiers = board_parser.soldiers
        location = Location[params[:location]]
        if location.key == :white
          soldiers = soldiers.collect(&:reverse)
        end
        soldiers
      end
    end

    include ActiveModel::Model

    attr_accessor :piece
    attr_accessor :promoted
    attr_accessor :point
    attr_accessor :location

    # def initialize(*)
    #   super
    #
    #   raise MustNotHappen, "location is blank" unless location
    # end

    def attributes
      raise MustNotHappen if promoted.nil?
      {piece: piece, promoted: promoted, point: point, location: location}
    end

    # 「１一香成」ではなく「１一杏」を返す
    # 指し手を返すには to_hand を使うこと
    def to_s
      name
    end

    def name
      "#{location ? location.name : '？'}#{point.name}#{any_name}"
    end

    def any_name
      piece.any_name(promoted)
    end

    def to_sfen
      piece.to_sfen(promoted: promoted, location: location)
    end

    # 現状の状態から成れるか？
    # 相手陣地から出たときのことは考慮しなくてよい
    # そもそも移動元をこのインスタンスは知らない
    def more_promote?(location)
      true &&
        piece.promotable? &&           # 成ることができる駒の種類かつ
        !promoted &&                   # まだ成っていないかつ
        point.promotable?(location) && # 現在地点は相手の陣地内か？
        true
    end

    # soldiers.sort できるようにする
    # 手合割などを調べる際に並び順で異なるオブジェクトと見なされないようにするためだけに用意したものなので何をキーにしてもよい
    def <=>(other)
      point <=> other.point
    end

    def reverse
      self.class.new(piece: piece, promoted: promoted, point: point.reverse, location: location.reverse)
    end

    def reverse_if_white
      if location.key == :white
        reverse
      else
        self
      end
    end

    def cached_vectors
      piece.cached_vectors(promoted: promoted, location: location)
    end

    def merge(attributes)
      self.class.new(self.attributes.merge(attributes))
    end

    def eql?(other)
      attributes == other.attributes
    end

    def hash
      attributes.hash
    end

    def ==(other)
      eql?(other)
    end
  end

  # Soldier にどこからどこへ成るかどうかの情報を含めたもの
  # origin_soldier と promoted_trigger が必要。どちらか一方だけで to_hand は作れる。
  class BattlerMove < Soldier
    attr_accessor :origin_soldier
    attr_accessor :promoted_trigger

    def attributes
      super.merge(origin_soldier: origin_soldier, promoted_trigger: promoted_trigger)
    end

    def to_hand
      [
        location.name,
        point.name,
        origin_soldier.any_name,
        promoted_trigger ? "成" : "",
        "(", origin_soldier.point.number_format, ")",
      ].join
    end
  end

  # 「打」専用
  class PieceStake < Soldier
    def to_hand
      "#{name}打"
    end
  end
end
