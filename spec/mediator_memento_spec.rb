require_relative "spec_helper"

module Warabi
  describe MediatorMemento do
    it do
      object = MediatorMemento.new
      object.mediator.board.placement_from_preset
      object.mediator.execute("▲７六歩")
      object.stack_push
      object.mediator.execute("△３四歩")
      object.stack_pop

      object = MediatorMemento.new
      object.mediator.object_id
      object_id = object.mediator.object_id
      object.stack_push
      (object.mediator.object_id != object_id).should == true
      object.stack_pop
      object.mediator.object_id
      (object.mediator.object_id == object_id).should == true
    end
  end
end
