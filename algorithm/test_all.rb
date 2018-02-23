require "test-unit"

require "./reversi_app"
require "./simple_minimax"
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
      obj.run
      assert_equal({"o" => 3, "x" => 13}, obj.app.histogram)
    end
  end
end
