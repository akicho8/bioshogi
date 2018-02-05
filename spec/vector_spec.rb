require_relative "spec_helper"

module Warabi
  describe Vector do
    it do
      Vector[1, 2].reverse_sign.should == Vector[-1, -2]
    end
  end
end
