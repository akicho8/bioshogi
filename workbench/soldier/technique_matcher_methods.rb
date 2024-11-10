require "./setup"
Soldier.from_str("▲19香").maeni_ittyokusen?                   # => true
Soldier.from_str("▲19飛").maeni_ittyokusen?                   # => true
Soldier.from_str("▲19杏").maeni_ittyokusen?                   # => false
Soldier.from_str("▲19角").maeni_ittyokusen?                   # => false

Soldier.from_str("△34飛").move_to_bottom_edge                 # => #<Bioshogi::Place ３一>
Soldier.from_str("△34飛").move_to_top_edge                    # => #<Bioshogi::Place ３九>
Soldier.from_str("△34飛").move_to_right_edge                  # => #<Bioshogi::Place ９四>
Soldier.from_str("△34飛").move_to_left_edge                   # => #<Bioshogi::Place １四>

Soldier.from_str("△34飛").top_spaces                          # => 5
Soldier.from_str("△34飛").bottom_spaces                       # => 3
Soldier.from_str("△34飛").left_spaces                         # => 2
Soldier.from_str("△34飛").right_spaces                        # => 6

Soldier.from_str("△34飛").column_is_two_to_eight?             # => true
Soldier.from_str("△34飛").column_is_two_or_eight?             # => false
Soldier.from_str("△34飛").column_is_three_to_seven?           # => true
Soldier.from_str("△34飛").column_is_center?                   # => false
Soldier.from_str("△34飛").column_is_edge?                     # => false
Soldier.from_str("△34飛").column_is_right_area?               # => false
Soldier.from_str("△34飛").column_is_left_area?                # => true
Soldier.from_str("△34飛").column_is_right_edge?               # => false
Soldier.from_str("△34飛").column_is_left_edge?                # => false

Soldier.from_str("△34飛").move_to(:up).name                   # => "３五"
Soldier.from_str("△34飛").move_to(:up, magnification: 0).name # => "３四"
Soldier.from_str("△34飛").move_to(:up, magnification: 1).name # => "３五"
Soldier.from_str("△34飛").move_to(:up, magnification: 2).name # => "３六"
