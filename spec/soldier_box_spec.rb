require_relative "spec_helper"

module Warabi
  describe SoldierBox do
    it do
      soldier_box = SoldierBox.new
      soldier_box << Soldier.from_str("△５一玉")
      soldier_box << Soldier.from_str("▲６八銀")
      soldier_box.collect(&:name).should                                                    == ["△５一玉", "▲６八銀"]
      soldier_box.sorted_soldiers.collect(&:name).should                                    == ["▲６八銀", "△５一玉"]
      soldier_box.place_as_key_table.transform_keys(&:to_s).transform_values(&:to_s).should == {"５一"=>"△５一玉", "６八"=>"▲６八銀"}
      soldier_box.location_split.transform_values { |e| e.collect(&:name) }.should          == {:black=>["▲６八銀"], :white=>["△５一玉"]}
      soldier_box.location_adjust.transform_values { |e| e.collect(&:name) }.should         == {:black=>["▲６八銀", "△５一玉"], :white=>["△４二銀", "▲５九玉"]}
    end
  end
end
