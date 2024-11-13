require "spec_helper"

module Bioshogi
  module Dimension
    describe ModuleMethods do
      it ".default_size?" do
        assert { Dimension.default_size? }
      end

      it ".current_size" do
        assert { Dimension.current_size == [9, 9] }
      end

      it ".change" do
        assert { !Dimension.change([2, 3]) { Dimension.default_size? } }
        assert { Dimension.default_size? }
      end
    end
  end
end
