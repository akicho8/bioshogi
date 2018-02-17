require "./example_helper"

sequencer = Sequencer.new NotationDsl.define { set :a, 1 }
sequencer.evaluate
sequencer.mediator_memento.mediator.variables # => {:a=>1}
