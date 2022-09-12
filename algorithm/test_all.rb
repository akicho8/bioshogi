require "test-unit"
require "./all_algorithms"

class TestAll < Test::Unit::TestCase
  test "all" do
    histograms = [
      DirtyMinimax,
      Minimax,
      NegaMax,
      NegaAlpha,
      NegaAlphaFs,
      # BuggyNegaScout,
      NegaScout,
    ].collect do |klass|
      xcontainer = klass.new
      xcontainer.params[:dimension] = 4
      xcontainer.params[:silent] = true
      xcontainer.params[:depth_max] = 3
      xcontainer.run
    end
    assert histograms.uniq.count == 1
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.657347 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 1.52 tests/s, 1.52 assertions/s
