require_relative "spec_helper"

module Warabi
  describe InputParser do
    it do
      list = [
        "６八銀左",
        "△６八全",
        "△６八銀成",
        "△６八銀打",
        "△同銀",
        "△同銀成",
        "７六歩(77)",
        "7677FU",
        "-7677FU",
        "+0077RY",
        "8c8d",
        "P*2f",
        "4e5c+",
      ]
      InputParser.scan(list.join).should == list
    end
  end
end
