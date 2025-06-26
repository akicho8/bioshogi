# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :ShapeAnalyzerMethods do
      def hold_piece_eq
        unless defined?(@hold_piece_eq)
          if v = super
            @hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_eq = nil
          end
        end

        @hold_piece_eq
      end

      def op_hold_piece_eq
        unless defined?(@op_hold_piece_eq)
          if v = super
            @op_hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @op_hold_piece_eq = nil
          end
        end

        @op_hold_piece_eq
      end

      def hold_piece_in
        unless defined?(@hold_piece_in)
          if v = super
            @hold_piece_in = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_in = nil
          end
        end

        @hold_piece_in
      end

      def hold_piece_not_in
        unless defined?(@hold_piece_not_in)
          if v = super
            @hold_piece_not_in = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_not_in = nil
          end
        end

        @hold_piece_not_in
      end
    end
  end
end
