require "test-unit"

require "./dirty_minimax"
require "./beauty_minimax"
require "./nega_max"
require "./nega_alpha"

class TestAll < Test::Unit::TestCase
  test "all" do
    [
      DirtyMinimax,
      BeautyMinimax,
      NegaMax,
      NegaAlpha,
    ].each do |klass|
      obj = klass.new
      obj.params[:silent] = true
      obj.params[:depth_max] = 3
      obj.run
      assert_equal({o: 8, x: 8}, obj.app.histogram)
    end
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.201192 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 4 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4.97 tests/s, 19.88 assertions/s
