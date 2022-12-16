# frozen-string-literal: true
module Bioshogi
  class SfenImporter
    def initialize(xcontainer, sfen_info)
      @xcontainer = xcontainer
      @sfen_info = sfen_info
    end

    def import_initial
      @sfen_info.soldiers.each do |soldier|
        player = @xcontainer.player_at(soldier.location)
        player.board.place_on(soldier, validate: true)
      end
      @xcontainer.turn_info.handicap = @sfen_info.handicap?
      @xcontainer.turn_info.turn_base = @sfen_info.turn_base
      @sfen_info.piece_counts.each do |location_key, counts|
        @xcontainer.player_at(location_key).piece_box.set(counts)
      end
      @xcontainer.before_run_process
    end

    def import_all
      import_initial
      @sfen_info.move_infos.each do |e|
        @xcontainer.execute(e[:input])
      end
    end
  end
end
