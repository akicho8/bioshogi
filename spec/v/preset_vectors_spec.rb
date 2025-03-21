require "spec_helper"

describe Bioshogi::V::PresetVectors do
  it "works" do
    assert { Bioshogi::V.around_vectors     }
    assert { Bioshogi::V.left_right_vectors }
    assert { Bioshogi::V.ikkenryu_vectors   }
    assert { Bioshogi::V.keima_vectors      }
    assert { Bioshogi::V.wariuchi_vectors   }
    assert { Bioshogi::V.ginbasami_verctors }
    assert { Bioshogi::V.tsugikei_vectors   }
  end
end
