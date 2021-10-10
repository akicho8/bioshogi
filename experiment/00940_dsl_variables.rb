require "./setup"

sequencer = Sequencer.new NotationDsl.define { set :a, 1 }
sequencer.evaluate
sequencer.mediator_stack.mediator.variables # => {:a=>1}
