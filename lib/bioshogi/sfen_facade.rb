# frozen-string-literal: true
module Bioshogi
  class SfenFacade
    # xcontainer 側に sfen を受け取るメソッドを入れる方法もある
    class Setup
      # @xcontainer = Xcontainer.new
      # @xcontainer.placement_from_preset("平手")
      # @xcontainer.to_history_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # @xcontainer.pieces_set("▲銀△銀銀")
      # puts @xcontainer
      # @xcontainer.board.to_sfen          # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
      # @xcontainer.to_history_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1"
      # @xcontainer.execute("▲６八銀")
      # @xcontainer.hand_logs.last.to_sfen # => "7i6h"
      # @xcontainer.to_history_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S2s 2"
      # @xcontainer.execute("△２四銀打")
      # @xcontainer.hand_logs.last.to_sfen # => "S*2d"
      # @xcontainer.to_history_sfen                # => "lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
      # @xcontainer.initial_state_board_sfen # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # puts @xcontainer.board
      # @xcontainer.to_source        # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"

      attr_accessor :sfen

      # xcontainer 側に sfen を受け取るメソッドを入れる方法も検討
      def xcontainer_board_setup(xcontainer)
        sfen.soldiers.each do |soldier|
          player = xcontainer.player_at(soldier.location)
          player.board.place_on(soldier, validate: true)
        end
        xcontainer.turn_info.handicap = sfen.handicap?
        xcontainer.turn_info.turn_base = sfen.turn_base
        sfen.piece_counts.each do |location_key, counts|
          xcontainer.player_at(location_key).piece_box.set(counts)
        end
        xcontainer.before_run_process
      end

      def execute_moves(xcontainer)
        sfen.move_infos.each do |e|
          xcontainer.execute(e[:input])
        end
      end
    end

    class SetupFromSource < Setup
      attr_accessor :xcontainer

      def execute(source)
        @sfen = Sfen.parse(source)

        @xcontainer = Xcontainer.new
        xcontainer_board_setup(@xcontainer)
        execute_moves(@xcontainer)
      end
    end
  end
end
