require "spec_helper"
require_relative "test_methods"

module Bioshogi
  module ScreenImage
    describe Renderer, screen_image: true do
      it "render" do
        renderer = target1
        assert { renderer.render }
        assert { renderer.to_blob_binary[1..3] == "PNG" }
        assert { renderer.to_write_binary[1..3] == "PNG" }
        assert { renderer.to_png24_binary[1..3] == "PNG" }
      end
    end
  end
end
