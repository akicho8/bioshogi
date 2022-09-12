require "./setup"

object = XcontainerStack.new
object.xcontainer.placement_from_preset("平手")
object.xcontainer.execute("▲７六歩")
object.stack_push
object.xcontainer.execute("△３四歩")
object.stack_pop

object = XcontainerStack.new
object.xcontainer.object_id
object_id = object.xcontainer.object_id
object.stack_push
object.xcontainer.object_id != object_id # => true
object.stack_pop
object.xcontainer.object_id
object.xcontainer.object_id == object_id # => true
