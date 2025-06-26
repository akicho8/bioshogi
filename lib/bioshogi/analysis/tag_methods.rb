module Bioshogi
  module Analysis
    concern :TagMethods do
      include BasicAccessor
      include ShapeAnalyzerMethods
      include ShapeInfoAccessor
      include TreeMod
      include StaticKifMod
      include StyleAccessor
    end
  end
end
