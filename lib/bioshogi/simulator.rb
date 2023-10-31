# frozen-string-literal: true

module Bioshogi
  class Simulator
    def self.run(...)
      new(...).tap(&:run)
    end

    attr_accessor :container
    attr_accessor :attributes
    attr_accessor :snapshots

    def initialize(attributes)
      @attributes = attributes
      @container = Container::Basic.new
      @snapshots = []
    end

    def run(&block)
      container.board.placement_from_any(attributes[:board])

      if v = attributes[:pieces]
        Location.each do |e|
          if str = v[e.key]
            container.player_at(e).pieces_add(str)
          end
        end
      end

      snapshots << container.deep_dup
      if block
        yield snapshots.last
      end
      InputParser.scan(attributes[:execute]).each do |str|
        container.execute(str)
        snapshots << container.deep_dup
        if block
          yield snapshots.last
        end
      end
      snapshots
    end
  end
end
