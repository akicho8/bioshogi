require "#{__dir__}/setup"
Soldier.from_str("▲19香").boar_mode?                   # => true
Soldier.from_str("▲19飛").boar_mode?                   # => true
Soldier.from_str("▲19杏").boar_mode?                   # => false
Soldier.from_str("▲19角").boar_mode?                   # => false

Soldier.from_str("△34飛").move_to_bottom_edge                 # => #<Bioshogi::Place ３一>
Soldier.from_str("△34飛").move_to_top_edge                    # => #<Bioshogi::Place ３九>
Soldier.from_str("△34飛").move_to_right_edge                  # => #<Bioshogi::Place ９四>
Soldier.from_str("△34飛").move_to_left_edge                   # => #<Bioshogi::Place １四>

Soldier.from_str("△51飛").king_default_place?                      # => true
Soldier.from_str("▲59飛").king_default_place?                      # => true

Soldier.from_str("△34飛").top_spaces                          # => 5
Soldier.from_str("△34飛").bottom_spaces                       # => 3
Soldier.from_str("△34飛").left_spaces                         # => 2
Soldier.from_str("△34飛").right_spaces                        # => 6

Soldier.from_str("△14飛").column_is2?         # => 
Soldier.from_str("△24飛").column_is2?         # => 
Soldier.from_str("△34飛").column_is2?         # => 

Soldier.from_str("△34飛").column_is_second_to_eighth?         # => 
Soldier.from_str("△34飛").column_is_second_or_eighth?         # => 
Soldier.from_str("△34飛").column_is_three_to_seven?           # => 
Soldier.from_str("△34飛").column_is_center?                   # => 
Soldier.from_str("△34飛").column_is_edge?                     # => 
Soldier.from_str("△34飛").column_is_right_side?               # => 
Soldier.from_str("△34飛").column_is_left_side?                # => 
Soldier.from_str("△34飛").column_is_right_edge?               # => 
Soldier.from_str("△34飛").column_is_left_edge?                # => 

Soldier.from_str("△34飛").relative_move_to(:up).name                   # => 
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 0).name # => 
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 1).name # => 
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 2).name # => 

Soldier.from_str("▲41歩").align_arrow # => 
Soldier.from_str("△41歩").align_arrow # => 
Soldier.from_str("▲51歩").align_arrow # => 
Soldier.from_str("△51歩").align_arrow # => 
Soldier.from_str("▲61歩").align_arrow # => 
Soldier.from_str("△61歩").align_arrow # => 

Soldier.from_str("▲11玉").both_side_without_corner? # => 
Soldier.from_str("▲12玉").both_side_without_corner? # => 
Soldier.from_str("▲18玉").both_side_without_corner? # => 
Soldier.from_str("▲19玉").both_side_without_corner? # => 

Soldier.from_str("△91玉").both_side_without_corner? # => 
Soldier.from_str("△92玉").both_side_without_corner? # => 
Soldier.from_str("△98玉").both_side_without_corner? # => 
Soldier.from_str("△99玉").both_side_without_corner? # => 

Soldier.from_str("△22玉").both_side_without_corner? # => 
# ~> -:20:in '<main>': undefined method 'column_is2?' for an instance of Bioshogi::Soldier (NoMethodError)
# ~> Did you mean?  column_is_edge?
# ~>                column_is_center?
