module Bioshogi
  module Analysis
    concern :TagMethods do
      include BasicAccessor
      include ShapeInfoAccessor
      include TreeMod
      include StaticKifMod
      include StyleAccessor
    end
  end
end
