require "spec_helper"

module Bioshogi
  describe SystemSupport do
    it "works" do
      expect { Bioshogi::SystemSupport.strict_system("exit 1") }.to raise_error(StandardError)
    end
  end
end
# >> .
# >> 
# >> Top 1 slowest examples (1.74 seconds, 99.7% of total time):
# >>   Bioshogi::SystemSupport works
# >>     1.74 seconds -:5
# >> 
# >> Finished in 1.75 seconds (files took 1.42 seconds to load)
# >> 1 example, 0 failures
# >> 
