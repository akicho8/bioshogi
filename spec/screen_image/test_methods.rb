module Bioshogi
  module ScreenImage
    module TestMethods
      def target1(params = {})
        parser = Parser.parse(Bioshogi::SFEN1)
        parser.screen_image_renderer(width: 2, height: 2, **params)
      end
    end

    RSpec.configure do |config|
      config.include(TestMethods, screen_image: true)
    end
  end
end
