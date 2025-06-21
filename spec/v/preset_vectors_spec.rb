require "spec_helper"

RSpec.describe Bioshogi::V::PresetVectors do
  it "works" do
    assert { Bioshogi::V.cross_vectors          }
    assert { Bioshogi::V.outer_vectors          }
    assert { Bioshogi::V.left_right_vectors     }
    assert { Bioshogi::V.ikkenryu_cross_vectors }
    assert { Bioshogi::V.keima_vectors          }
    assert { Bioshogi::V.wariuchi_vectors       }
    assert { Bioshogi::V.ginbasami_verctors     }
    assert { Bioshogi::V.tsugikei_vectors       }
  end

  it "軸反転系" do
    assert { (Bioshogi::V.right * Bioshogi::V.reverse_x) == Bioshogi::V.left }
    assert { (Bioshogi::V.up    * Bioshogi::V.reverse_y) == Bioshogi::V.down }
  end
end
