require "spec_helper"

RSpec.describe Bioshogi::BoardParser::KakinokiBoardParser do
  it "works" do
    assert { Bioshogi::BoardParser::KakinokiBoardParser.accept?("+--+") }
    assert { Bioshogi::BoardParser::KakinokiBoardParser.accept?("|・|") }
    assert { !Bioshogi::BoardParser::KakinokiBoardParser.accept?("")    }
    assert { !Bioshogi::BoardParser::KakinokiBoardParser.accept?(nil)   }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> .
# >>
# >> Bioshogi::Top 1 slowest examples (0.00018 seconds, 3.7% of total time):
# >>   Bioshogi::BoardParser::KakinokiBoardParser works
# >>     0.00018 seconds -:5
# >>
# >> Bioshogi::Finished in 0.00495 seconds (files took 1.47 seconds to load)
# >> 1 example, 0 failures
# >>
