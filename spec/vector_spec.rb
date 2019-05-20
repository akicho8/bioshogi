require_relative "spec_helper"

module Bioshogi
  describe Pvec do
    it do
      assert { Pvec[1, 2].flip_sign == Pvec[-1, -2] }
    end
  end
end
