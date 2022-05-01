# frozen-string-literal: true

module Bioshogi
  class Simulator
    def self.run(*args, &block)
      new(*args, &block).tap(&:run)
    end

    attr_accessor :mediator
    attr_accessor :attributes
    attr_accessor :snapshots

    def initialize(attributes)
      @attributes = attributes
      @mediator = Mediator.new
      @snapshots = []
    end

    def run(&block)
      mediator.board.placement_from_any(attributes[:board])

      if v = attributes[:pieces]
        LocationInfo.each do |e|
          if str = v[e.key]
            mediator.player_at(e).pieces_add(str)
          end
        end
      end

      snapshots << mediator.deep_dup
      if block
        yield snapshots.last
      end
      InputParser.scan(attributes[:execute]).each do |str|
        mediator.execute(str)
        snapshots << mediator.deep_dup
        if block
          yield snapshots.last
        end
      end
      snapshots
    end
  end
end
