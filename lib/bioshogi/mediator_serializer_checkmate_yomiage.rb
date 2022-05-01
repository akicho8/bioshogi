module Bioshogi
  class MediatorSerializerCheckmateYomiage
    attr_accessor :mediator
    attr_accessor :options

    SYMBOL_TO_SLEEP_ARGUMENT = {
      :sep1 => 0.5,
      :sep2 => 1.0,
    }

    def initialize(mediator, options = {})
      @mediator = mediator
      @options = options
    end

    # 以前の方法
    def to_s
      av = []
      av.concat(soldiers)
      av.push(piece_box)
      av = av.flatten
      av = av.find_all { |e| e.kind_of?(String) }
      av = av.join("。")
      av
    end

    # 新しい方法
    def to_a
      av = []
      av.concat(soldiers)
      av.push(piece_box)
      av = av.flatten
      if av.last.kind_of?(Symbol)
        av.pop
      end
      av = av.collect { |e|
        if e.kind_of?(String)
          { command: "talk", message: e }
        else
          { command: "interval", sleep: SYMBOL_TO_SLEEP_ARGUMENT.fetch(e), sleep_key: e }
        end
      }
      av
    end

    private

    def soldiers
      soldiers = mediator.board.soldiers
      group = soldiers.group_by(&:location)
      group = group.transform_values do |soldiers|
        soldiers = soldiers.sort_by { |e|
          [e.place.y.to_sfen, e.place.x.to_sfen]
        } # 右上から横に走査する順
        soldiers = soldiers.collect { |e|
          [e.place.yomiage, e.yomiage].join.squish
        }
        soldiers = append_separator(soldiers, :sep2)
      end
      av = Location.collect { |e|
        [e.checkmate_yomiage, :sep1, group[e] || ["なし", :sep1]]
      }
      av = av.reverse           # 相手から読み上げるため
      # append_separator(av, :sep1)
    end

    def piece_box
      piece_box = mediator.player_at(:black).piece_box # 白側の持駒は無視
      piece_counts = piece_box.sort_by { |e, count| -Piece.fetch(e).basic_weight }
      av = piece_counts.collect { |e, count|
        [Piece.fetch(e).yomiage(false), :sep1] * count
      }
      av = av.presence || ["なし", :sep1]
      ["もちごま", :sep1, av]
    end

    # def array_separator(ary, separator)
    #   ary.flat_map { |e| [e, separator] }[0..-2]
    # end

    def append_separator(ary, separator)
      ary.flat_map { |e| [e, separator] }
    end
  end
end
