# frozen-string-literal: true

module Warabi
  class SoldierBox < Array
    ################################################################################ 全体

    def soldiers
      self
    end

    def sorted_soldiers
      @sorted_soldiers ||= soldiers.sort
    end

    def point_as_key_table
      @point_as_key_table ||= soldiers.inject({}) { |a, e| a.merge(e.point => e) }
    end

    ################################################################################ ▲または△から見た状態に補正した全体のデータ

    def location_adjust
      @location_adjust ||= Location.inject({}) do |a, location|
        a.merge(location.key => sorted_soldiers.collect { |e| e.public_send(location.normalize_key) })
      end
    end

    ################################################################################ ▲△に分割

    def both_board_info
      @both_board_info ||= Location.inject({}) { |a, e| a.merge(e.key => []) }.merge(sorted_soldiers.group_by { |e| e.location.key })
    end
  end
end
