require "./example_helper"

object = TurnInfo.new(handicap: true)
object                          # => #<0:△上手>
object.counter += 1
object                          # => #<1:▲下手>

Parser.parse("６八銀").mediator.turn_info.turn_max # => 1
