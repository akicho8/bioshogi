require "./setup"
Board.create_by_preset("平手").lookup("11")               # => <Bioshogi::Soldier "△１一香">
Board.create_by_preset("平手").lookup("12")               # => nil
Board.create_by_preset("平手")["11"]                      # => <Bioshogi::Soldier "△１一香">
Board.new.fetch("55") rescue $!.class                     # => Bioshogi::PieceNotFoundOnBoard
Board.create_by_preset("平手").cell_empty?("11")          # => false
Board.create_by_preset("平手").cell_empty?("12")          # => true
Board.create_by_preset("平手").blank_places.count         # => 41
Board.create_by_preset("平手").vertical_soldiers(1).count # => 6
Board.create_by_preset("平手").soldiers.count             # => 40
Board.create_by_preset("平手").to_piece_box               # => {:lance=>4, :pawn=>18, :knight=>4, :rook=>2, :bishop=>2, :silver=>4, :gold=>4, :king=>2}
Board.create_by_preset("平手").to_s_soldiers              # => "１一香 １七歩 １三歩 １九香 ２一桂 ２七歩 ２三歩 ２九桂 ２二角 ２八飛 ３一銀 ３七歩 ３三歩 ３九銀 ４一金 ４七歩 ４三歩 ４九金 ５一玉 ５七歩 ５三歩 ５九玉 ６一金 ６七歩 ６三歩 ６九金 ７一銀 ７七歩 ７三歩 ７九銀 ８一桂 ８七歩 ８三歩 ８九桂 ８二飛 ８八角 ９一香 ９七歩 ９三歩 ９九香"
Board.create_by_preset("平手").preset_info                # => <平手>
Board.create_by_preset("平手").to_kif                     # => "  ９ ８ ７ ６ ５ ４ ３ ２ １\n+---------------------------+\n|v香v桂v銀v金v玉v金v銀v桂v香|一\n| ・v飛 ・ ・ ・ ・ ・v角 ・|二\n|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|四\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|五\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|六\n| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七\n| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八\n| 香 桂 銀 金 玉 金 銀 桂 香|九\n+---------------------------+\n"
Board.create_by_preset("平手").to_ki2                     # => "  ９ ８ ７ ６ ５ ４ ３ ２ １\n+---------------------------+\n|v香v桂v銀v金v玉v金v銀v桂v香|一\n| ・v飛 ・ ・ ・ ・ ・v角 ・|二\n|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|四\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|五\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|六\n| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七\n| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八\n| 香 桂 銀 金 玉 金 銀 桂 香|九\n+---------------------------+\n"
Board.create_by_preset("平手").to_csa                     # => "P1-KY-KE-GI-KI-OU-KI-GI-KE-KY\nP2 * -HI *  *  *  *  * -KA * \nP3-FU-FU-FU-FU-FU-FU-FU-FU-FU\nP4 *  *  *  *  *  *  *  *  * \nP5 *  *  *  *  *  *  *  *  * \nP6 *  *  *  *  *  *  *  *  * \nP7+FU+FU+FU+FU+FU+FU+FU+FU+FU\nP8 * +KA *  *  *  *  * +HI * \nP9+KY+KE+GI+KI+OU+KI+GI+KE+KY\n"
Board.create_by_preset("平手").to_s                       # => "  ９ ８ ７ ６ ５ ４ ３ ２ １\n+---------------------------+\n|v香v桂v銀v金v玉v金v銀v桂v香|一\n| ・v飛 ・ ・ ・ ・ ・v角 ・|二\n|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|四\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|五\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|六\n| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七\n| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八\n| 香 桂 銀 金 玉 金 銀 桂 香|九\n+---------------------------+\n"
Board.create_by_preset("平手").to_sfen                    # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
