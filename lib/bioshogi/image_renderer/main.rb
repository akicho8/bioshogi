module Bioshogi
  module ImageRenderer
    class Main
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
