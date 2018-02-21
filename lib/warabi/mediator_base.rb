# frozen-string-literal: true

module Warabi
  concern :MediatorBase do
    attr_writer :board

    def params
      @params ||= {
        skill_monitor_enable: false,
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    def to_mini
      mediator = MediatorSimple.new
      mediator.players = players.dup
      mediator
    end

    def context_new(&block)
      yield deep_dup
    end

    def inspect
      to_s
    end

    def board
      @board ||= Board.new
    end

    def position_map
      @position_map ||= Hash.new(0)
    end

    def position_hash
      board.hash ^ players.collect(&:piece_box).hash ^ turn_info.current_location.hash
    end

    def placement_from_bod(str)
      if md = str.match(/(?<board>^\+\-.*\-\+$)/m)
        board.placement_from_shape md[:board]
      end
      str.scan(/(.*)の持駒：(.*)/) do |location_key, piece_str|
        player_at(location_key).pieces_set(piece_str)
      end
      if md = str.match(/^手数\s*＝\s*(?<counter>\d+)/)
        turn_info.counter = md[:counter].to_i
      end
      if Location.any? { |e| str.include?(e.handicap_name) }
        turn_info.handicap = true
      end
    end
  end
end
