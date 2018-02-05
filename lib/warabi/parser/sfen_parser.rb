# frozen-string-literal: true

module Warabi
  module Parser
    class SfenParser < Base
      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(/^position\s+/)
        end
      end

      def parse
        @sfen = Usi::Sfen.parse(normalized_source)
        @move_infos = @sfen.move_infos

        @sfen.hold_pieces.each do |location, pieces|
          name = location.call_name(@sfen.komaochi?)
          header["#{name}の持駒"] = Utils.hold_pieces_a_to_s(pieces)
        end
      end

      def mediator_board_setup(mediator)
        usi = Usi::Class1.new
        usi.sfen = @sfen
        usi.board_setup(mediator)
      end
    end
  end
end
