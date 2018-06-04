require_relative "spec_helper"

module Warabi
  describe Vector do
    it do
      assert { Vector[1, 2].flip_sign == Vector[-1, -2] }
    end
  end
end
