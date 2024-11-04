require "spec_helper"

module Bioshogi
  describe V::PresetVectors do
    it "works" do
      assert { V.around_vectors     }
      assert { V.left_right_vectors }
      assert { V.ikkenryu_vectors   }
      assert { V.keima_vectors      }
      assert { V.wariuchi_vectors   }
      assert { V.ginbasami_verctors }
      assert { V.tsugikei_vectors   }
    end
  end
end
