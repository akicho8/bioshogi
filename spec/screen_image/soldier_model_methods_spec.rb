require "spec_helper"

describe Bioshogi::ScreenImage::SoldierModelMethods, screen_image: true do
  it "image_basename" do
    assert { Bioshogi::Soldier.from_str("△34歩").image_basename == "WP0" }
  end
end
