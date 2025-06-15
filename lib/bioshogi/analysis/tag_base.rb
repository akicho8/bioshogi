module Bioshogi
  module Analysis
    concern :TagBase do
      include ShapeInfoRelation
      include BasicAccessor
      include TreeMod
      include StaticKifMod
      include StyleAccessor
    end
  end
end
