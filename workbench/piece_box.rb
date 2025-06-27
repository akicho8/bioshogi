require "#{__dir__}/setup"

piece_box = PieceBox.new(Piece.s_to_h("玉"))
piece_box.to_h                                 # => {king: 1}
piece_box[:king]                               # => 1
piece_box.clear                                # => {}

piece_box = PieceBox.new(Piece.s_to_h("玉"))
piece_box.to_h                                 # => {king: 1}
piece_box.to_sfen(:black)                      # => "K"
piece_box.to_csa(:black)                       # => "P+00OU"
piece_box.set(Piece.s_to_h("飛玉角角"))        # => {rook: 1, king: 1, bishop: 2}
piece_box.to_h                                 # => {rook: 1, king: 1, bishop: 2}
piece_box.pick_out("歩") rescue $!             # => #<Bioshogi::HoldPieceNotFound: 持駒から歩を取り出そうとしましたが歩を持っていません : {rook: 1, king: 1, bishop: 2}>
piece_box.pick_out("飛").key                   # => :rook
piece_box.to_h                                 # => {king: 1, bishop: 2}
piece_box.pick_out_without_king.collect(&:key) # => [:bishop, :bishop]
piece_box.exist?(:bishop)                      # => true
piece_box.exist?(:rook)                        # => false
piece_box.add(:bishop => 1)                    # => {king: 1, bishop: 3}
piece_box.to_h                                 # => {king: 1, bishop: 3}
piece_box.to_sfen(:black)                      # => "K3B"
piece_box.to_csa(:black)                       # => "P+00OU00KA00KA00KA"
piece_box.to_s(separator: "/")                 # => "玉/角三"
piece_box.score                                # => 45670

PieceBox.real_box # => {king: 2, rook: 2, bishop: 2, gold: 4, silver: 4, knight: 4, lance: 4, pawn: 18}

hash = { :king => 1 }.freeze
piece_box = PieceBox.new(hash)  # => {king: 1}
piece_box.add(king: 1)
piece_box                       # => {king: 2}
hash                            # => {king: 1}

a = PieceBox.new(Piece.s_to_h("飛玉"))
b = PieceBox.new(Piece.s_to_h("玉飛"))
a == b                          # => true

a = PieceBox.new(Piece.s_to_h("歩飛"))
