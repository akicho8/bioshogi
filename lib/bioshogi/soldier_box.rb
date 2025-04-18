# frozen-string-literal: true

#
# soldier_box = SoldierBox.new
# soldier_box << Soldier.from_str("△５一玉")
# soldier_box << Soldier.from_str("▲６八銀")
# soldier_box.collect(&:name)                                             # => ["△５一玉", "▲６八銀"]
# soldier_box.sorted_soldiers.collect(&:name)                             # => ["▲６八銀", "△５一玉"]
# soldier_box.place_as_key_table.collect { |p, s| [p.name, s.name] }.to_h # => {"５一"=>"△５一玉", "６八"=>"▲６八銀"}
# soldier_box.location_split.transform_values { |e| e.collect(&:name) }   # => {:black=>["▲６八銀"], :white=>["△５一玉"]}
# soldier_box.location_adjust.transform_values { |e| e.collect(&:name) }  # => {:black=>["▲６八銀", "△５一玉"], :white=>["△４二銀", "▲５九玉"]}
#
module Bioshogi
  class SoldierBox < Array
    def soldiers
      self
    end

    def sorted_soldiers
      @sorted_soldiers ||= soldiers.sort.freeze
    end

    def place_as_key_table
      @place_as_key_table ||= soldiers.inject({}) { |a, e| a.merge(e.place => e) }.freeze
    end

    # ▲または△から見た状態に補正した全体のデータ
    def location_adjust
      @location_adjust ||= Location.inject({}) { |a, location|
        a.merge(location.key => sorted_soldiers.collect { |e| e.public_send(location.normalize_key) })
      }.freeze
    end

    # ▲△に分割
    def location_split
      @location_split ||= Location.inject({}) { |a, e| a.merge(e.key => []) }.merge(sorted_soldiers.group_by { |e| e.location.key }).freeze
    end
  end
end
