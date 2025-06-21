require "#{__dir__}/setup"

bp = Analysis::DefenseInfo["四段端玉"].board_parser
tp bp.other_objects_loc_ary           # => {black: {"◇" => [{place: #<Bioshogi::Place ９五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ８五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ７五>, prefix_char: " ", something: "◇"}], "◆" => [{place: #<Bioshogi::Place ８六>, prefix_char: " ", something: "◆"}, {place: #<Bioshogi::Place ７六>, prefix_char: " ", something: "◆"}]}, white: {"◇" => [{place: #<Bioshogi::Place １五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ２五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ３五>, prefix_char: " ", something: "◇"}], "◆" => [{place: #<Bioshogi::Place ２四>, prefix_char: " ", something: "◆"}, {place: #<Bioshogi::Place ３四>, prefix_char: " ", something: "◆"}]}}
tp bp.other_objects_loc_ary[:black]   # => {"◇" => [{place: #<Bioshogi::Place ９五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ８五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ７五>, prefix_char: " ", something: "◇"}], "◆" => [{place: #<Bioshogi::Place ８六>, prefix_char: " ", something: "◆"}, {place: #<Bioshogi::Place ７六>, prefix_char: " ", something: "◆"}]}
tp bp.other_objects_loc_ary[:black]["◆"] # => [{place: #<Bioshogi::Place ８六>, prefix_char: " ", something: "◆"}, {place: #<Bioshogi::Place ７六>, prefix_char: " ", something: "◆"}]
tp tp bp.trigger_soldiers

info = Parser.file_parse("囲い/四段端玉.kif")
puts info.formatter.container
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:25:in 'IO.read': No such file or directory @ rb_sysopen - /Users/ikeda/src/bioshogi/workbench/囲い/四段端玉.kif (Errno::ENOENT)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:25:in 'Pathname#read'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:25:in 'Bioshogi::Parser#file_parse'
# ~> 	from -:9:in '<main>'
# >> |-------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | black | {"◇" => [{place: #<Bioshogi::Place ９五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ８五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ７五>, prefix_char: " ", something: "◇"}], "◆" => [{place: #<Bioshogi::Place ８六>, prefix_ch... |
# >> | white | {"◇" => [{place: #<Bioshogi::Place １五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ２五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ３五>, prefix_char: " ", something: "◇"}], "◆" => [{place: #<Bioshogi::Place ２四>, prefix_ch... |
# >> |-------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |----+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | ◇ | [{place: #<Bioshogi::Place ９五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ８五>, prefix_char: " ", something: "◇"}, {place: #<Bioshogi::Place ７五>, prefix_char: " ", something: "◇"}] |
# >> | ◆ | [{place: #<Bioshogi::Place ８六>, prefix_char: " ", something: "◆"}, {place: #<Bioshogi::Place ７六>, prefix_char: " ", something: "◆"}]                                                                      |
# >> |----+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-------+-------------+-----------|
# >> | place | prefix_char | something |
# >> |-------+-------------+-----------|
# >> | ８六  |             | ◆        |
# >> | ７六  |             | ◆        |
# >> |-------+-------------+-----------|
# >> |----------|
# >> | ▲９六玉 |
# >> |----------|
# >> |----------|
# >> | ▲９六玉 |
# >> |----------|
