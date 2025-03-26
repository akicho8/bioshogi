require "spec_helper"

RSpec.describe Bioshogi::Analysis::BoardPieceCountsMethods do
  it "specific_piece_counts" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.specific_piece_count_for(:white, :bishop) == 1 }
    board.safe_delete_on(Bioshogi::Place["22"])
    assert { board.specific_piece_count_for(:white, :bishop) == 0 }
  end

  it "location_piece_counts" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.location_piece_counts == { white: 20, black: 20 } }
    board.safe_delete_on(Bioshogi::Place["22"])
    assert { board.location_piece_counts == { white: 19, black: 20 } }
  end
end
# >> Bioshogi::Analysis::Coverage report generated for Bioshogi::Analysis::RSpec to /Bioshogi::Analysis::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::Analysis::LOC (38.46%) covered.
# >> Bioshogi::Analysis::FF
# >>
# >> Bioshogi::Analysis::Failures:
# >>
# >>   1) Bioshogi::Board::BoardPieceCountsMethods piece_counts
# >>      Bioshogi::Analysis::Failure/Bioshogi::Analysis::Error: Bioshogi::Analysis::Unable to find - to read failed line
# >>
# >>      Bioshogi::Analysis::NoMethodError:
# >>        undefined method `specific_piece_counts' for #<Bioshogi::Board::Basic:0x00000001054d5570 @surface={#<Bioshogi::Place ９一>=><Bioshogi::Soldier "△９一香">, #<Bioshogi::Place ９三>=><Bioshogi::Soldier "△９三歩">, #<Bioshogi::Place ９七>=><Bioshogi::Soldier "▲９七歩">, #<Bioshogi::Place ９九>=><Bioshogi::Soldier "▲９九香">, #<Bioshogi::Place ８一>=><Bioshogi::Soldier "△８一桂">, #<Bioshogi::Place ８二>=><Bioshogi::Soldier "△８二飛">, #<Bioshogi::Place ８三>=><Bioshogi::Soldier "△８三歩">, #<Bioshogi::Place ８七>=><Bioshogi::Soldier "▲８七歩">, #<Bioshogi::Place ８八>=><Bioshogi::Soldier "▲８八角">, #<Bioshogi::Place ８九>=><Bioshogi::Soldier "▲８九桂">, #<Bioshogi::Place ７一>=><Bioshogi::Soldier "△７一銀">, #<Bioshogi::Place ７三>=><Bioshogi::Soldier "△７三歩">, #<Bioshogi::Place ７七>=><Bioshogi::Soldier "▲７七歩">, #<Bioshogi::Place ７九>=><Bioshogi::Soldier "▲７九銀">, #<Bioshogi::Place ６一>=><Bioshogi::Soldier "△６一金">, #<Bioshogi::Place ６三>=><Bioshogi::Soldier "△６三歩">, #<Bioshogi::Place ６七>=><Bioshogi::Soldier "▲６七歩">, #<Bioshogi::Place ６九>=><Bioshogi::Soldier "▲６九金">, #<Bioshogi::Place ５一>=><Bioshogi::Soldier "△５一玉">, #<Bioshogi::Place ５三>=><Bioshogi::Soldier "△５三歩">, #<Bioshogi::Place ５七>=><Bioshogi::Soldier "▲５七歩">, #<Bioshogi::Place ５九>=><Bioshogi::Soldier "▲５九玉">, #<Bioshogi::Place ４一>=><Bioshogi::Soldier "△４一金">, #<Bioshogi::Place ４三>=><Bioshogi::Soldier "△４三歩">, #<Bioshogi::Place ４七>=><Bioshogi::Soldier "▲４七歩">, #<Bioshogi::Place ４九>=><Bioshogi::Soldier "▲４九金">, #<Bioshogi::Place ３一>=><Bioshogi::Soldier "△３一銀">, #<Bioshogi::Place ３三>=><Bioshogi::Soldier "△３三歩">, #<Bioshogi::Place ３七>=><Bioshogi::Soldier "▲３七歩">, #<Bioshogi::Place ３九>=><Bioshogi::Soldier "▲３九銀">, #<Bioshogi::Place ２一>=><Bioshogi::Soldier "△２一桂">, #<Bioshogi::Place ２二>=><Bioshogi::Soldier "△２二角">, #<Bioshogi::Place ２三>=><Bioshogi::Soldier "△２三歩">, #<Bioshogi::Place ２七>=><Bioshogi::Soldier "▲２七歩">, #<Bioshogi::Place ２八>=><Bioshogi::Soldier "▲２八飛">, #<Bioshogi::Place ２九>=><Bioshogi::Soldier "▲２九桂">, #<Bioshogi::Place １一>=><Bioshogi::Soldier "△１一香">, #<Bioshogi::Place １三>=><Bioshogi::Soldier "△１三歩">, #<Bioshogi::Place １七>=><Bioshogi::Soldier "▲１七歩">, #<Bioshogi::Place １九>=><Bioshogi::Soldier "▲１九香">}, @piller_counts={0=>4, 1=>6, 2=>4, 3=>4, 4=>4, 5=>4, 6=>4, 7=>6, 8=>4}, @active=false, @piece_counts={[:white, :lance]=>2, [:white, :pawn]=>9, [:black, :pawn]=>9, [:black, :lance]=>2, [:white, :knight]=>2, [:white, :rook]=>1, [:black, :bishop]=>1, [:black, :knight]=>2, [:white, :silver]=>2, [:black, :silver]=>2, [:white, :gold]=>2, [:black, :gold]=>2, [:white, :king]=>1, [:black, :king]=>1, [:white, :bishop]=>1, [:black, :rook]=>1}>
# >>      # -:6:in `block (3 levels) in <# >>      # -:6:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Board::BoardPieceCountsMethods location_piece_counts
# >>      Bioshogi::Analysis::Failure/Bioshogi::Analysis::Error: Bioshogi::Analysis::Unable to find - to read failed line
# >>
# >>      Bioshogi::Analysis::NoMethodError:
# >>        undefined method `location_piece_counts' for #<Bioshogi::Board::Basic:0x00000001054f9510 @surface={#<Bioshogi::Place ９一>=><Bioshogi::Soldier "△９一香">, #<Bioshogi::Place ９三>=><Bioshogi::Soldier "△９三歩">, #<Bioshogi::Place ９七>=><Bioshogi::Soldier "▲９七歩">, #<Bioshogi::Place ９九>=><Bioshogi::Soldier "▲９九香">, #<Bioshogi::Place ８一>=><Bioshogi::Soldier "△８一桂">, #<Bioshogi::Place ８二>=><Bioshogi::Soldier "△８二飛">, #<Bioshogi::Place ８三>=><Bioshogi::Soldier "△８三歩">, #<Bioshogi::Place ８七>=><Bioshogi::Soldier "▲８七歩">, #<Bioshogi::Place ８八>=><Bioshogi::Soldier "▲８八角">, #<Bioshogi::Place ８九>=><Bioshogi::Soldier "▲８九桂">, #<Bioshogi::Place ７一>=><Bioshogi::Soldier "△７一銀">, #<Bioshogi::Place ７三>=><Bioshogi::Soldier "△７三歩">, #<Bioshogi::Place ７七>=><Bioshogi::Soldier "▲７七歩">, #<Bioshogi::Place ７九>=><Bioshogi::Soldier "▲７九銀">, #<Bioshogi::Place ６一>=><Bioshogi::Soldier "△６一金">, #<Bioshogi::Place ６三>=><Bioshogi::Soldier "△６三歩">, #<Bioshogi::Place ６七>=><Bioshogi::Soldier "▲６七歩">, #<Bioshogi::Place ６九>=><Bioshogi::Soldier "▲６九金">, #<Bioshogi::Place ５一>=><Bioshogi::Soldier "△５一玉">, #<Bioshogi::Place ５三>=><Bioshogi::Soldier "△５三歩">, #<Bioshogi::Place ５七>=><Bioshogi::Soldier "▲５七歩">, #<Bioshogi::Place ５九>=><Bioshogi::Soldier "▲５九玉">, #<Bioshogi::Place ４一>=><Bioshogi::Soldier "△４一金">, #<Bioshogi::Place ４三>=><Bioshogi::Soldier "△４三歩">, #<Bioshogi::Place ４七>=><Bioshogi::Soldier "▲４七歩">, #<Bioshogi::Place ４九>=><Bioshogi::Soldier "▲４九金">, #<Bioshogi::Place ３一>=><Bioshogi::Soldier "△３一銀">, #<Bioshogi::Place ３三>=><Bioshogi::Soldier "△３三歩">, #<Bioshogi::Place ３七>=><Bioshogi::Soldier "▲３七歩">, #<Bioshogi::Place ３九>=><Bioshogi::Soldier "▲３九銀">, #<Bioshogi::Place ２一>=><Bioshogi::Soldier "△２一桂">, #<Bioshogi::Place ２二>=><Bioshogi::Soldier "△２二角">, #<Bioshogi::Place ２三>=><Bioshogi::Soldier "△２三歩">, #<Bioshogi::Place ２七>=><Bioshogi::Soldier "▲２七歩">, #<Bioshogi::Place ２八>=><Bioshogi::Soldier "▲２八飛">, #<Bioshogi::Place ２九>=><Bioshogi::Soldier "▲２九桂">, #<Bioshogi::Place １一>=><Bioshogi::Soldier "△１一香">, #<Bioshogi::Place １三>=><Bioshogi::Soldier "△１三歩">, #<Bioshogi::Place １七>=><Bioshogi::Soldier "▲１七歩">, #<Bioshogi::Place １九>=><Bioshogi::Soldier "▲１九香">}, @piller_counts={0=>4, 1=>6, 2=>4, 3=>4, 4=>4, 5=>4, 6=>4, 7=>6, 8=>4}, @active=false, @piece_counts={[:white, :lance]=>2, [:white, :pawn]=>9, [:black, :pawn]=>9, [:black, :lance]=>2, [:white, :knight]=>2, [:white, :rook]=>1, [:black, :bishop]=>1, [:black, :knight]=>2, [:white, :silver]=>2, [:black, :silver]=>2, [:white, :gold]=>2, [:black, :gold]=>2, [:white, :king]=>1, [:black, :king]=>1, [:white, :bishop]=>1, [:black, :rook]=>1}>
# >>      # -:11:in `block (3 levels) in <# >>      # -:11:in `block (2 levels) in <# >>
# >> Bioshogi::Analysis::Top 2 slowest examples (0.01914 seconds, 58.6% of total time):
# >>   Bioshogi::Board::BoardPieceCountsMethods piece_counts
# >>     0.0175 seconds -:5
# >>   Bioshogi::Board::BoardPieceCountsMethods location_piece_counts
# >>     0.00164 seconds -:9
# >>
# >> Bioshogi::Analysis::Finished in 0.03265 seconds (files took 2.8 seconds to load)
# >> 2 examples, 2 failures
# >>
# >> Bioshogi::Analysis::Failed examples:
# >>
# >> rspec -:5 # Bioshogi::Board::BoardPieceCountsMethods piece_counts
# >> rspec -:9 # Bioshogi::Board::BoardPieceCountsMethods location_piece_counts
# >>
