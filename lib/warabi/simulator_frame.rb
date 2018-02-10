# frozen-string-literal: true

module Warabi
  class SimulatorFrame < Mediator
    def initialize(pattern)
      super()
      @pattern = pattern

      # Location.each{|loc|
      #   player_join(Player.new(location: loc))
      # }

      board_reset(@pattern[:board])

      if @pattern[:pieces]
        Location.each do |loc|
          players[loc.index].pieces_add(@pattern[:pieces][loc.key])
        end
      end
    end

    def build_frames(&block)
      snapshots = []
      snapshots << deep_dup
      if block
        yield snapshots.last
      end
      Utils.ki2_parse(@pattern[:execute]).each do |op|
        if op.kind_of?(String)
          raise SyntaxDefact, op
        end
        player_at(op[:location]).execute(op[:input])
        snapshots << deep_dup
        if block
          yield snapshots.last
        end
      end
      snapshots
    end
  end
end
