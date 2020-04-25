# frozen-string-literal: true

module Bioshogi
  concern :MediatorBase do
    attr_writer :board

    def before_run_process
    end

    def params
      @params ||= {
        skill_monitor_enable: false,
        skill_monitor_technique_enable: false,
        candidate_enable: true,
        validate_enable: true,
        board_class: Board,
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    def context_new(&block)
      yield deep_dup
    end

    def inspect
      to_s
    end

    def board
      @board ||= params[:board_class].new
    end

    def one_place_map
      @one_place_map ||= Hash.new(0)
    end

    def one_place_hash
      board.hash ^ players.collect(&:piece_box).hash ^ turn_info.current_location.hash
    end

    def placement_from_bod(str)
      str = str.lines.collect(&:strip).join("\n")
      if md = str.match(/(?<board>^\+\-.*\-\+$)/m)
        board.placement_from_shape md[:board]
      end
      str.scan(/(.*)の持駒：(.*)/) do |location_key, piece_str|
        player_at(location_key).pieces_set(piece_str)
      end

      if md = str.match(/^手数\s*(＝|=)\s*(?<counter>\d+)/)
        turn_info.turn_base = md[:counter].to_i
      end

      # 手合割は bod の仕様にはないはずだけどあれば駒落ちの判断材料にはなる
      if md = str.match(/^手合割：\s*(\S+)\s*/)
        preset_info = PresetInfo.fetch(md.captures.first)
        turn_info.handicap = preset_info.handicap
      end

      # 「上手」「下手」の名前がどこかに使われていれば駒落ち(雑)
      if Location.any? { |e| str.include?(e.handicap_name) }
        turn_info.handicap = true
      end
    end

    def placement_from_preset(value = nil)
      board.placement_from_preset(value)

      # 手番の反映
      preset_info = PresetInfo.fetch(value || :"平手")
      turn_info.handicap = preset_info.handicap
      turn_info.turn_base = 0 # FIXME: いる？
      turn_info.turn_offset = 0      # FIXME: いる？

      # 玉の位置を取得
      players.each(&:king_place_update)
    end
  end
end
