# frozen-string-literal: true
module Bushido
  class Usi
    # mediator 側に sfen を受け取るメソッドを入れる方法もある
    class Class1
      # @mediator = Mediator.new
      # @mediator.board_reset
      # @mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # @mediator.pieces_set("▲銀△銀銀")
      # puts @mediator
      # @mediator.board.to_sfen          # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
      # @mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1"
      # @mediator.execute("▲６八銀")
      # @mediator.hand_logs.last.to_sfen # => "7i6h"
      # @mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S2s 2"
      # @mediator.execute("△２四銀打")
      # @mediator.hand_logs.last.to_sfen # => "S*2d"
      # @mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
      # @mediator.first_state_board_sfen # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # puts @mediator.board
      # @mediator.to_source        # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"

      attr_accessor :sfen

      # mediator 側に sfen を受け取るメソッドを入れる方法も検討
      def board_setup(mediator)
        case
        when sfen.attributes[:startpos]
          mediator.board_reset
        when sfen.attributes[:sfen]
          sfen.soldiers.each do |soldier|
            player = mediator.player_at(soldier[:location])
            player.battlers_create_from_soldier(soldier)
          end
          mediator.turn_info.komaochi = sfen.komaochi?
          mediator.turn_info.counter = sfen.turn_counter
          sfen.hold_pieces.each do |location, pieces|
            player = mediator.player_at(location)
            player.pieces.concat(pieces)
          end
        else
          raise MustNotHappen
        end
        mediator.play_standby
      end

      def execute_moves(mediator)
        sfen.move_infos.each do |e|
          mediator.execute(e[:input])
        end
      end
    end

    class Class2 < Class1
      attr_accessor :mediator

      def execute(source)
        @sfen = Sfen.parse(source)

        @mediator = Mediator.new
        board_setup(@mediator)
        execute_moves(@mediator)
      end
    end

    class Sfen
      attr_reader :attributes
      attr_reader :source

      def self.parse(source)
        new(source).tap(&:parse)
      end

      def initialize(source)
        @source = source
      end

      # {sfen: "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", b_or_w: "b", hold_pieces: "S2s", turn_counter_next: "1", moves: "7i6h S*2d"}
      def parse
        md = @source.match(/position\s+(sfen\s+(?<sfen>\S+)\s+(?<b_or_w>\S+)\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)|(?<startpos>startpos))(\s+moves\s+(?<moves>.*))?/)
        unless md
          raise SyntaxDefact, "構文が不正です : #{@source.inspect}"
        end
        @attributes = md.named_captures.symbolize_keys
      end

      def soldiers
        [].tap do |soldiers|
          attributes[:sfen].split("/").each.with_index do |row, y|
            x = 0
            row.scan(/(\+?)(.)/) do |promoted, ch|
              point = Point.fetch([x, y])
              if ch.match?(/\d+/)
                x += ch.to_i
              else
                location = Location.fetch_by_sfen_char(ch)
                promoted = (promoted == "+")
                piece = Piece.fetch_by_sfen_char(ch)
                soldiers << Soldier[piece: piece, point: point, location: location, promoted: promoted]
                x += 1
              end
            end
          end
        end
      end

      def location
        Location.fetch(attributes[:b_or_w])
      end

      def hold_pieces
        {}.tap do |pieces|
          if str = attributes[:hold_pieces]
            if str != "-"
              str.scan(/(\d+)?(.)/) do |count, ch|
                count = (count || 1).to_i
                piece = Piece.fetch_by_sfen_char(ch)
                location = Location.fetch_by_sfen_char(ch)
                pieces[location] ||= []
                pieces[location].concat([piece] * count)
              end
            end
          end
        end
      end

      def turn_counter
        if attributes[:turn_counter_next]
          attributes[:turn_counter_next].to_i.pred
        end
      end

      # 手番の最初 (手番が偶数) が "w" なら駒落ちと判断
      def komaochi?
        turn_counter.even? && location.key == :white
      end

      def move_infos
        attributes[:moves].to_s.split(/\s+/).collect do |e|
          {input: e}
        end
      end
    end
  end
end
