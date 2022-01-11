require "spec_helper"

module Bioshogi
  describe AkfBuilder do
    it "works" do
      assert { Parser.parse("68S").to_akf }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) Bioshogi::AkfBuilder works
# >>      Failure/Error: :last_action_kakinoki_word => @parser.last_action_info.kakinoki_word,
# >> 
# >>      NoMethodError:
# >>        undefined method `kakinoki_word' for nil:NilClass
# >>      # ./lib/bioshogi/akf_builder.rb:67:in `to_h'
# >>      # ./lib/bioshogi/formatter/export_methods.rb:390:in `to_akf'
# >>      # -:6:in `block (3 levels) in <module:Bioshogi>'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:6:in `block (2 levels) in <module:Bioshogi>'
# >> 
# >> Top 1 slowest examples (0.74889 seconds, 99.2% of total time):
# >>   Bioshogi::AkfBuilder works
# >>     0.74889 seconds -:5
# >> 
# >> Finished in 0.7546 seconds (files took 1.84 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:5 # Bioshogi::AkfBuilder works
# >> 
