require "./setup"
Board.create_by_preset("平手").lookup("11")               # => <Bioshogi::Soldier "△１一香">
Board.create_by_preset("平手").lookup("12")               # => nil
Board.create_by_preset("平手")["11"]                      # => <Bioshogi::Soldier "△１一香">
Board.new.fetch("55") rescue $!.class                     # => 
Board.create_by_preset("平手").empty_cell?("11")          # => 
Board.create_by_preset("平手").empty_cell?("12")          # => 
Board.create_by_preset("平手").blank_places.count         # => 
Board.create_by_preset("平手").vertical_soldiers(1).count # => 
Board.create_by_preset("平手").soldiers.count             # => 
Board.create_by_preset("平手").to_piece_box               # => 
Board.create_by_preset("平手").to_s_soldiers              # => 
Board.create_by_preset("平手").preset_info                # => 
Board.create_by_preset("平手").to_kif                     # => 
Board.create_by_preset("平手").to_ki2                     # => 
Board.create_by_preset("平手").to_csa                     # => 
Board.create_by_preset("平手").to_s                       # => 
Board.create_by_preset("平手").to_sfen                    # => 
