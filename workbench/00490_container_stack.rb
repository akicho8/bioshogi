require "#{__dir__}/setup"

object = Container::ContainerStack.new
object.container.placement_from_preset("平手")
object.container.execute("▲７六歩")
object.stack_push
object.container.execute("△３四歩")
object.stack_pop

object = Container::ContainerStack.new
object.container.object_id
object_id = object.container.object_id
object.stack_push
object.container.object_id != object_id # => true
object.stack_pop
object.container.object_id
object.container.object_id == object_id # => true
