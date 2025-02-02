require "spec_helper"
require_relative "test_methods"

module Bioshogi
  module ScreenImage
    describe PieceImageInfo, screen_image: true do
      it "互換性のため Portella でも引ける" do
        assert { PieceImageInfo.fetch("Portella") }
        assert { PieceImageInfo.fetch("portella") }
      end
    end
  end
end
