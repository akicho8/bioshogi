# frozen-string-literal: true

module Bioshogi
  class Simulator
    def self.run(*args, &block)
      new(*args, &block).tap(&:run)
    end

    attr_accessor :xcontainer
    attr_accessor :attributes
    attr_accessor :snapshots

    def initialize(attributes)
      @attributes = attributes
      @xcontainer = Xcontainer.new
      @snapshots = []
    end

    def run(&block)
      xcontainer.board.placement_from_any(attributes[:board])

      if v = attributes[:pieces]
        Location.each do |e|
          if str = v[e.key]
            xcontainer.player_at(e).pieces_add(str)
          end
        end
      end

      snapshots << xcontainer.deep_dup
      if block
        yield snapshots.last
      end
      InputParser.scan(attributes[:execute]).each do |str|
        xcontainer.execute(str)
        snapshots << xcontainer.deep_dup
        if block
          yield snapshots.last
        end
      end
      snapshots
    end
  end
end
