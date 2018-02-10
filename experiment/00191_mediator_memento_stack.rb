require "./example_helper"

object = MediatorMemento.new
object.mediator.board_reset
object.mediator.execute("▲７六歩")
object.stack_push
object.mediator.execute("△３四歩")
object.stack_pop

object = MediatorMemento.new
object.mediator.object_id
object_id = object.mediator.object_id
object.stack_push
object.mediator.object_id != object_id # => true
object.stack_pop
object.mediator.object_id
object.mediator.object_id == object_id # => true
