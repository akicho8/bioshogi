require_relative "spec_helper"

module Bushido
  describe Teban do
    it "駒落ちなので△から始まる" do
      teban = Teban.new("香車落ち")
      teban.current_location.key == :white
    end

    it "平手なので▲から始まる" do
      teban = Teban.new("平手")
      teban.current_location.key == :black
    end
  end
end
