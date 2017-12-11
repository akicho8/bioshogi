require "./example_helper"

# mediator = Mediator.new
# mediator.board_reset
# mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
# mediator.pieces_set("▲銀△銀銀")
# puts mediator
# mediator.board.to_sfen          # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
# mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1"
# mediator.execute("▲６八銀")
# mediator.hand_logs.last.to_sfen # => "7i6h"
# mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S2s 2"
# mediator.execute("△２四銀打")
# mediator.hand_logs.last.to_sfen # => "S*2d"
# mediator.to_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
# mediator.first_state_board_sfen # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
# puts mediator.board
# mediator.to_usi_position        # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"

usi_position = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
# usi_position = "position startpos moves 7i6h S*2d"
if md = usi_position.match(/position\s+(sfen\s+(?<sfen>\S+)\s+(?<b_or_w>\S+)\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)|startpos)\s+(moves\s+(?<moves>.*))?/)
  params = md.named_captures.symbolize_keys             # => {:sfen=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", :b_or_w=>"b", :hold_pieces=>"S2s", :turn_counter_next=>"1", :moves=>"7i6h S*2d"}

  mediator = Mediator.new
  if params[:sfen]
    params[:sfen].split("/").each.with_index do |row, y|
      x = 0
      row.scan(/(\+?)(.)/) do |promoted, ch|
        xy = [x, y]
        point = Point.parse(xy)

        if ch.match?(/\d+/)
          x += ch.to_i
        else
          location = Location.fetch_by_sfen_char(ch)
          player = mediator.player_at(location)
          promoted = (promoted == "+")

          piece = Piece.fetch_by_sfen_char(ch)
          player.battlers_create_from_soldier(Soldier[piece: piece, point: point, location: location, promoted: promoted])

          x += 1
        end
      end
    end

    if params[:turn_counter_next].to_i.odd? && params[:b_or_w] == "w" # "1" (奇数) のとき "w" なら駒落ちと判断
      mediator.turn_info.komaochi = true
    end
    mediator.turn_info.counter = params[:turn_counter_next].to_i.pred

    if params[:hold_pieces]
      if params[:hold_pieces] != "-"
        params[:hold_pieces].scan(/(\d+)?(.)/) do |count, ch|
          count = (count || 1).to_i
          piece = Piece.fetch_by_sfen_char(ch)
          location = Location.fetch_by_sfen_char(ch)
          player = mediator.player_at(location)
          player.pieces.concat([piece] * count)
        end
      end
    end
  else
    mediator.board_reset
  end

  mediator.play_standby
  if params[:moves]
    params[:moves].split(/\s+/).each do |e|
      mediator.execute(e)
    end
  end

  puts mediator
  puts mediator.to_usi_position
end
# >> 後手の持駒：銀
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・v銀 ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：銀
# >> 手数＝2 △２四銀打 まで
# >> position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d
