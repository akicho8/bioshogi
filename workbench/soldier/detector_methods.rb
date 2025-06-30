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
Soldier.from_str("△34飛").left_space                         # => 2
Soldier.from_str("△34飛").right_space                        # => 6

Soldier.from_str("△14飛").column_eq?(2)         # => false
Soldier.from_str("△24飛").column_eq?(2)         # => false
Soldier.from_str("△34飛").column_eq?(2)         # => false

Soldier.from_str("△34飛").column_is2to8?         # => true
Soldier.from_str("△34飛").column_is2or8?         # => false
Soldier.from_str("△34飛").column_is3to7?           # => true
Soldier.from_str("△34飛").column_is5?                   # => false
Soldier.from_str("△34飛").side_edge?                     # => false
Soldier.from_str("△34飛").right_side?               # => false
Soldier.from_str("△34飛").left_side?                # => true
Soldier.from_str("△34飛").right_edge?               # => false
Soldier.from_str("△34飛").left_edge?                # => false

Soldier.from_str("△34飛").relative_move_to(:up).name                   # => "３五"
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 0).name # => "３四"
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 1).name # => "３五"
Soldier.from_str("△34飛").relative_move_to(:up, magnification: 2).name # => "３六"

Soldier.from_str("▲41歩").left_or_right # => :right
Soldier.from_str("△41歩").left_or_right # => :left
Soldier.from_str("▲51歩").left_or_right # => nil
Soldier.from_str("△51歩").left_or_right # => nil
Soldier.from_str("▲61歩").left_or_right # => :left
Soldier.from_str("△61歩").left_or_right # => :right

Soldier.from_str("▲11玉").both_side_without_corner? # => false
Soldier.from_str("▲12玉").both_side_without_corner? # => true
Soldier.from_str("▲18玉").both_side_without_corner? # => true
Soldier.from_str("▲19玉").both_side_without_corner? # => false

Soldier.from_str("△91玉").both_side_without_corner? # => false
Soldier.from_str("△92玉").both_side_without_corner? # => true
Soldier.from_str("△98玉").both_side_without_corner? # => true
Soldier.from_str("△99玉").both_side_without_corner? # => false

Soldier.from_str("△22玉").both_side_without_corner? # => false
