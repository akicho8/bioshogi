require "./setup"

sequencer = Sequencer.new NotationDsl.define { set :a, 1 }
sequencer.evaluate
sequencer.xcontainer_stack.xcontainer.variables # => {:a=>1}
