# frozen-string-literal: true
module Bushido
  class Usi
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
    # @mediator.to_usi_position        # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"

    attr_accessor :mediator

    def execute(usi_position)
      # usi_position = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
      # usi_position = "position startpos moves 7i6h S*2d"

      @mediator = Mediator.new

      md = usi_position.match(/position\s+(sfen\s+(?<sfen>\S+)\s+(?<b_or_w>\S+)\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)|(?<startpos>startpos))(\s+moves\s+(?<moves>.*))?/)
      unless md
        raise SyntaxDefact, usi_position
      end

      params = md.named_captures.symbolize_keys # => {:sfen=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", :b_or_w=>"b", :hold_pieces=>"S2s", :turn_counter_next=>"1", :moves=>"7i6h S*2d"}

      case
      when params[:startpos]
        @mediator.board_reset
      when params[:sfen]
        params[:sfen].split("/").each.with_index do |row, y|
          x = 0
          row.scan(/(\+?)(.)/) do |promoted, ch|
            point = Point.parse([x, y])

            if ch.match?(/\d+/)
              x += ch.to_i
            else
              location = Location.fetch_by_sfen_char(ch)
              player = @mediator.player_at(location)
              promoted = (promoted == "+")

              piece = Piece.fetch_by_sfen_char(ch)
              player.battlers_create_from_soldier(Soldier[piece: piece, point: point, location: location, promoted: promoted])

              x += 1
            end
          end
        end

        if params[:turn_counter_next].to_i.odd? && params[:b_or_w] == "w" # "1" (奇数) のとき "w" なら駒落ちと判断
          @mediator.turn_info.komaochi = true
        end
        @mediator.turn_info.counter = params[:turn_counter_next].to_i.pred

        if params[:hold_pieces]
          if params[:hold_pieces] != "-"
            params[:hold_pieces].scan(/(\d+)?(.)/) do |count, ch|
              count = (count || 1).to_i
              piece = Piece.fetch_by_sfen_char(ch)
              location = Location.fetch_by_sfen_char(ch)
              player = @mediator.player_at(location)
              player.pieces.concat([piece] * count)
            end
          end
        end
      end

      @mediator.play_standby
      if params[:moves]
        params[:moves].split(/\s+/).each do |e|
          @mediator.execute(e)
        end
      end
    end
  end
end
