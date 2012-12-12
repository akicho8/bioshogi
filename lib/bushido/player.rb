# -*- coding: utf-8 -*-
module Bushido
  class Player
    attr_accessor :name, :field, :location, :pieces, :frame, :before_point

    def initialize(name, field, location)
      @name = name
      @field = field
      @location = location

      deal
    end

    def deal
      @pieces = first_distributed_pieces.collect{|info|
        info[:count].times.collect{ Piece.get!(info[:piece]) }
      }.flatten
    end

    def first_distributed_pieces
      [
        {:count => 9, :piece => "歩"},
        {:count => 1, :piece => "角"},
        {:count => 1, :piece => "飛"},
        {:count => 2, :piece => "香"},
        {:count => 2, :piece => "桂"},
        {:count => 2, :piece => "銀"},
        {:count => 2, :piece => "金"},
        {:count => 1, :piece => "玉"},
      ]
    end

    def setup
      table = first_placements.collect{|arg|parse_arg(arg)}
      if @location == :upper
        table.each{|info|info[:point] = info[:point].reverse}
      end
      side_soldiers_put_on(table)
    end

    def side_soldiers_put_on(table)
      table.each{|info|initial_put_on(info)}
    end

    def initial_put_on(arg)
      info = parse_arg(arg)
      @field.put_on_at(info[:point], Soldier.new(self, pick_out(info[:piece]), info[:promoted]))
    end

    def parse_arg(arg)
      if arg.kind_of?(String)
        info = parse_string_arg(arg)
        if info[:options] == "成"
          raise SyntaxError, "駒の配置するときは「○成」ではなく「成○」: #{arg.inspect}"
        end
        info
      else
        if true
          # FIXME: ここ使ってないわりにごちゃごちゃしているから消そう
          piece = arg[:piece]
          promoted = arg[:promoted]
          if piece.kind_of?(String)
            promoted, piece = Piece.parse!(piece)
          end
          arg.merge(:point => Point[arg[:point]], :piece => piece, :promoted => promoted)
        else
          arg
        end
      end
    end

    def parse_string_arg(str)
      md = str.match(/\A(?<point>..)(?<piece>#{Piece.names.join("|")})(?<options>.*)/)
      md or raise SyntaxError, "表記が間違っています : #{str.inspect}"
      point = Point.parse(md[:point])
      promoted, piece = Piece.parse!(md[:piece])
      {:point => point, :piece => piece, :promoted => promoted, :options => md[:options]}
    end

    def first_placements
      [
        "9七歩", "8七歩", "7七歩", "6七歩", "5七歩", "4七歩", "3七歩", "2七歩", "1七歩",
        "8八角", "2八飛",
        "9九香", "8九桂", "7九銀", "6九金", "5九玉", "4九金", "3九銀", "2九桂", "1九香",
      ]
    end

    def arrow
      @location == :lower ? "" : "↓"
    end

    # FIXME: 先手後手と、位置は別に考えた方がいい
    def location_mark
      @location == :lower ? "▲" : "▽"
    end

    def piece_fetch!(piece)
      @pieces.find{|e|e.class == piece.class} or raise PieceNotFound, "持駒に#{piece.name}がありません"
    end

    def pick_out(piece)
      @pieces.delete(piece_fetch!(piece))
    end

    def soldiers
      @field.matrix.values.find_all{|soldier|soldier.player == self}
    end

    def move_to(a, b, promote_trigger = false)
      a = Point.parse(a)
      b = Point.parse(b)

      if promote_trigger
        if a.promotable_area?(location) || b.promotable_area?(location)
        else
          raise NotPromotable, "#{a.name}から#{b.name}への移動では成れません"
        end

        _soldier = @field.fetch(a)
        if _soldier.promoted
          raise AlredyPromoted, "#{_soldier.current_point.name}の#{_soldier.piece.name}はすでに成っています"
        end
      end

      soldier = @field.pick_up!(a)
      target_soldier = @field.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.name}があります"
        end
        @field.pick_up!(b)
        @pieces << target_soldier.piece
      end

      if promote_trigger
        soldier.promoted = true
      end

      @field.put_on_at(b, soldier)
    end

    def next_player
      if @frame
        @frame.players[@frame.players.find_index(self).next.modulo(frame.players.size)]
      else
        self
      end
    end

    def execute(str)
      md = str.match(/\A(?<point>..|同)(?<piece>#{Piece.names.join("|")})(?<options>成|打)?(\((?<from>.*)\))?/)
      if md[:point] == "同"
        point = next_player.before_point
      else
        point = Point.parse(md[:point])
      end
      promoted, piece = Piece.parse!(md[:piece])
      promote_trigger = md[:options] == "成"
      put_on_trigger = md[:options] == "打"
      source_point = nil

      if put_on_trigger
        if promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{str.inspect}"
        end
        @field.put_on_at(point, Soldier.new(self, pick_out(piece), promoted))
      else
        if md[:from]
          source_point = Point.parse(md[:from])
        end

        unless source_point
          soldiers = soldiers()

          soldiers = soldiers.find_all{|soldier|
            soldier.moveable_points.include?(point)
          }

          if piece # MEMO: いまんとこ絶対通るけど、駒の指定がなくても動かせるようにしたいので。
            soldiers = soldiers.find_all{|e|e.piece.class == piece.class}
          end

          if soldiers.empty?
            raise MovableSoldierNotFound, "#{point.name}に移動できる#{piece.name}がありません。#{str.inspect} の指定が間違っているのかもしれません"
          end

          if soldiers.size > 1
            raise AmbiguousFormatError, "#{point.name}に来れる駒が多すぎます。#{str.inspect} の表記を明確にしてください。(移動元候補: #{soldiers.collect(&:name).join(', ')})"
          end

          source_point = @field.matrix.invert[soldiers.first]
        end

        source_soldier = @field.fetch(source_point)

        unless promote_trigger
          if source_soldier.promoted && !promoted
            raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{str.inspect}の駒は#{source_soldier.piece_current_name}と書いてください"
          end
        end

        move_to(source_point, point, promote_trigger)
      end

      @before_point = point
    end
  end
end
