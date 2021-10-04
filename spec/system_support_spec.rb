require "spec_helper"

module Bioshogi
  describe SystemSupport do
    it "works" do
      expect { Bioshogi::SystemSupport.strict_system("ruby -e 'exit(1)'") }.to raise_error(StandardError)
    end
  end
end
# >> .
# >> 
# >> Top 1 slowest examples (2.48 seconds, 99.7% of total time):
# >>   Bioshogi::SystemSupport works
# >>     2.48 seconds -:5
# >> 
# >> Finished in 2.49 seconds (files took 1.3 seconds to load)
# >> 1 example, 0 failures
# >> 
