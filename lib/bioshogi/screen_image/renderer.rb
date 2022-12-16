module Bioshogi
  module ScreenImage
    class Renderer
      include Builder
      include CoreMethods
      include BoardMethods
      include LayerMethods
      include Pentagon
      include SoldierMethods
      include Stand
      include TurnMethods
      include Helper
    end
  end
end
