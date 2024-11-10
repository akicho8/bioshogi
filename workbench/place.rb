require "./setup"

Place[[9, 0]]                 # => nil

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Bioshogi::Place １一>, #<Bioshogi::Place ２一>]
[a, b].sort                     # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]

Place["１一"].object_id         # => 2040
Place["11"].object_id           # => 2040

# Dimension::DimensionColumn.fetch(1).object_id # => 70357212614280
# Dimension::DimensionColumn.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => -2656019782535967827
Place["７６"].hash              # => -2656019782535967827
Place["76"].object_id           # => 2060
Place["７６"].object_id         # => 2060
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => 3664671274976281473
[1, 2].hash                     # => 3664671274976281473

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
