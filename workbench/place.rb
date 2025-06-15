require "./setup"
def _
  "%.1f ms" % Benchmark.ms { 1000000.times { yield } }
end

a = Place["55"]                     # => #<Bioshogi::Place ５五>
_ { a.to_a }                # => "109.3 ms"

Place["55"].row.name        # => "五"
Place["55"].column.name     # => "５"

Place[[9, 0]]                 # => nil

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Bioshogi::Place １一>, #<Bioshogi::Place ２一>]
[a, b].sort                     # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]

Place["１一"].object_id         # => 864
Place["11"].object_id           # => 864

Place["11"].to_human_h          # => {column: 1, row: 1}

# Dimension::Column.fetch(1).object_id # => 70357212614280
# Dimension::Column.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => 2894204950855917639
Place["７６"].hash              # => 2894204950855917639
Place["76"].object_id           # => 872
Place["７６"].object_id         # => 872
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => 728421501128345460
[1, 2].hash                     # => 728421501128345460

################################################################################

Place["55"].relative_move_to(Location[:white], V.up)                  # => #<Bioshogi::Place ５六>
Place["55"].relative_move_to(Location[:white], :up)                   # => #<Bioshogi::Place ５六>
Place["55"].relative_move_to(Location[:white], :up, magnification: 0) # => #<Bioshogi::Place ５五>
Place["55"].relative_move_to(Location[:white], :up, magnification: 2) # => #<Bioshogi::Place ５七>
Place["55"].relative_move_to(Location[:white], :up, magnification: 9) # => nil

Place["55"].move_to_bottom_edge(Location[:white])            # => #<Bioshogi::Place ５一>
Place["55"].move_to_top_edge(Location[:white])               # => #<Bioshogi::Place ５九>
Place["55"].move_to_left_edge(Location[:white])              # => #<Bioshogi::Place １五>
Place["55"].move_to_right_edge(Location[:white])             # => #<Bioshogi::Place ９五>

Place["51"].king_default_place?(Location[:white]) # => true
Place["59"].king_default_place?(Location[:black]) # => true

################################################################################

Place["55"].manhattan_distance(Place["55"]) # => 0
Place["55"].manhattan_distance(Place["54"]) # => 1
Place["55"].manhattan_distance(Place["44"]) # => 2
Place["55"].manhattan_distance(Place["45"]) # => 1
Place["55"].manhattan_distance(Place["46"]) # => 2
Place["55"].manhattan_distance(Place["56"]) # => 1
Place["55"].manhattan_distance(Place["66"]) # => 2
Place["55"].manhattan_distance(Place["65"]) # => 1
Place["55"].manhattan_distance(Place["64"]) # => 2

Place["55"].manhattan_distance(Place["55"]) # => 0
Place["55"].manhattan_distance(Place["66"]) # => 2
Place["55"].manhattan_distance(Place["77"]) # => 4
Place["55"].manhattan_distance(Place["88"]) # => 6

Place["55"].manhattan_distance_a_side_max(Place["55"]) # => 0
Place["55"].manhattan_distance_a_side_max(Place["66"]) # => 1
Place["55"].manhattan_distance_a_side_max(Place["77"]) # => 2
Place["55"].manhattan_distance_a_side_max(Place["78"]) # => 3

Place["55"].in_outer_area?(Place["55"], 2) # => true
Place["55"].in_outer_area?(Place["66"], 2) # => true
Place["55"].in_outer_area?(Place["77"], 2) # => true
Place["55"].in_outer_area?(Place["78"], 2) # => false

Place["55"].both_side_without_corner? # => false
