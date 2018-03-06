require "./example_helper"

InputParser.scan("▲４二銀△４二銀４五歩▲４二銀") # => [{:location=>:black, :input=>"４二銀"}, {:location=>:white, :input=>"４二銀４五歩"}, {:location=>:black, :input=>"４二銀"}]
