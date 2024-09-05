require "spec_helper"

module Bioshogi
  RSpec.describe BoardParser::KakinokiBoardParser do
    it "works" do
      assert { BoardParser::KakinokiBoardParser.accept?("+--+") }
      assert { BoardParser::KakinokiBoardParser.accept?("|・|") }
      assert { !BoardParser::KakinokiBoardParser.accept?("")    }
      assert { !BoardParser::KakinokiBoardParser.accept?(nil)   }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.00018 seconds, 3.7% of total time):
# >>   Bioshogi::BoardParser::KakinokiBoardParser works
# >>     0.00018 seconds -:5
# >> 
# >> Finished in 0.00495 seconds (files took 1.47 seconds to load)
# >> 1 example, 0 failures
# >> 
