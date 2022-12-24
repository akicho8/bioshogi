require "spec_helper"
require_relative "test_methods"

module Bioshogi
  module ScreenImage
    describe PieceFontWeightInfo, screen_image: true do
      describe "全パターン確認" do
        PieceFontWeightInfo.each do |e|
          it e.key do
            assert { target1(piece_font_weight_key: e.key).render }
          end
        end
      end
    end
  end
end
