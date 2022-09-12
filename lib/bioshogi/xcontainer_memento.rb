# frozen-string-literal: true

module Bioshogi
  concern :XcontainerMemento do
    def create_memento
      Marshal.load(Marshal.dump([board, players.collect(&:piece_box), turn_info]))
    end

    def restore_memento(memento)
      @board, piece_boxs, @turn_info = memento
      players.each.with_index do |player, i|
        player.piece_box = piece_boxs[i]
      end
    end
  end
end
