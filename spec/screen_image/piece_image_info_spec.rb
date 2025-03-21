require "spec_helper"
require_relative "test_methods"

describe Bioshogi::ScreenImage::PieceImageInfo, screen_image: true do
  it "互換性のため Portella でも引ける" do
    assert { Bioshogi::ScreenImage::PieceImageInfo.fetch("Portella") }
    assert { Bioshogi::ScreenImage::PieceImageInfo.fetch("portella") }
  end
end
