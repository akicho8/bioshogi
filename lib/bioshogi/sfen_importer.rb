# frozen-string-literal: true
module Bioshogi
  class SfenImporter
    def initialize(container, sfen_info)
      @container = container
      @sfen_info = sfen_info
    end

    def import_initial
      @sfen_info.soldiers.each do |soldier|
        player = @container.player_at(soldier.location)
        player.board.place_on(soldier, validate: true)
      end
      @container.turn_info.handicap = @sfen_info.handicap?
      @container.turn_info.turn_base = @sfen_info.turn_base
      @sfen_info.piece_counts.each do |location_key, counts|
        @container.player_at(location_key).piece_box.set(counts)
      end
      @container.before_run_process
    end

    def import_all
      import_initial
      @sfen_info.move_infos.each do |e|
        @container.execute(e[:input])
      end
    end
  end
end
