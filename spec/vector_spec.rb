require "spec_helper"

module Bushido
  describe Vector do
    it do
      Vector[1, 2].reverse_sign.should == Vector[-1, -2]
    end
  end
end
