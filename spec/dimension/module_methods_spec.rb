require "spec_helper"

RSpec.describe Bioshogi::Dimension::ModuleMethods do
  it ".default_size?" do
    assert { Bioshogi::Dimension.default_size? }
  end

  it ".current_size" do
    assert { Bioshogi::Dimension.current_size == [9, 9] }
  end

  it ".change" do
    assert { !Bioshogi::Dimension.change([2, 3]) { Bioshogi::Dimension.default_size? } }
    assert { Bioshogi::Dimension.default_size? }
  end
end
