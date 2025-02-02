require "spec_helper"

module Bioshogi
  module ScreenImage
    describe SoldierModelMethods, screen_image: true do
      it "image_basename" do
        assert { Soldier.from_str("△34歩").image_basename == "WP0" }
      end
    end
  end
end
