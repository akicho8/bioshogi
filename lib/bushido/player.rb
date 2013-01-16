# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  class Player
    # facade
    def self.test_case(params = {})
      params = {
        :player => :black,
        :return_player => false,
      }.merge(params)
      player = Player.create2(params[:player], Board.new)
      player.deal(params[:deal])
      player.initial_put_on(params[:init])
      Array.wrap(params[:exec]).each{|v|player.execute(v)}
      if params[:return_player]
        player
      else
        player.soldier_names.sort
      end
    end

    # facade
    def self.test_case2(params = {})
      test_case({:return_player => true}.merge(params))
    end

    # 互換性のため一時的に。
    def self.create2(location, board)
      new.tap do |o|
        o.location = location
        o.board = board
        o.deal
      end
    end

    # 互換性のため一時的に。
    def self.create1(location)
      new.tap do |o|
        o.location = location
        o.deal
      end
    end

    attr_accessor :name, :board, :location, :pieces, :frame, :moved_point, :last_piece

    def initialize
      @pieces = []
    end

    # 配布して持駒にする
    #
    #   player = Player.new
    #   player.deal("飛 歩二")
    #   player.pieces_compact_str # => "飛 歩二"
    #
    def deal(infos = first_distributed_pieces)
      if infos.kind_of? String
        str = infos
        str = str.tr("〇一二三四五六七八九", "0-9")
        infos = str.split(/#{WHITE_SPACE}+/).collect{|s|
          md = s.match(/\A(?<piece>#{Piece.names.join("|")})(?<count>\d+)?/)
          {:piece => md[:piece], :count => (md[:count] || 1).to_i}
        }
      end
      Array.wrap(infos).each{|info|
        @pieces += (info[:count] || 1).times.collect{ Piece.get!(info[:piece]) }
      }
    end

    def first_distributed_pieces
      [
        {:piece => "歩", :count => 9},
        {:piece => "角", :count => 1},
        {:piece => "飛", :count => 1},
        {:piece => "香", :count => 2},
        {:piece => "桂", :count => 2},
        {:piece => "銀", :count => 2},
        {:piece => "金", :count => 2},
        {:piece => "玉", :count => 1},
      ]
    end

    def piece_plot
      table = first_placements.collect{|arg|parse_arg(arg)}
      if @location == :white
        table.each{|info|info[:point] = info[:point].reverse}
      end
      side_soldiers_put_on(table)
    end

    def side_soldiers_put_on(table)
      table.each{|info|initial_put_on(info)}
    end

    def initial_put_on(arg)
      Array.wrap(arg).each{|arg|
        next if arg.to_s.gsub(/_/, "").blank? # テストを書きやすくするため
        info = parse_arg(arg)
        soldier = Soldier.new(self, pick_out(info[:piece]), info[:promoted])
        @board.put_on_at(info[:point], soldier)
      }
    end

    def parse_arg(arg)
      if arg.kind_of?(String)
        info = parse_string_arg(arg)
        if info[:options] == "成"
          raise SyntaxError, "駒の配置するときは「○成」ではなく「成○」: #{arg.inspect}"
        end
        info
      else
        if true
          # FIXME: ここ使ってないわりにごちゃごちゃしているから消そう
          piece = arg[:piece]
          promoted = arg[:promoted]
          if piece.kind_of?(String)
            promoted, piece = Piece.parse!(piece)
          end
          arg.merge(:point => Point[arg[:point]], :piece => piece, :promoted => promoted)
        else
          arg
        end
      end
    end

    def parse_string_arg(str)
      md = str.match(/\A(?<point>..)(?<piece>#{Piece.names.join("|")})(?<options>.*)/)
      md or raise SyntaxError, "表記が間違っています : #{str.inspect}"
      point = Point.parse(md[:point])
      promoted, piece = Piece.parse!(md[:piece])
      {:point => point, :piece => piece, :promoted => promoted, :options => md[:options]}
    end

    def first_placements
      [
        "9七歩", "8七歩", "7七歩", "6七歩", "5七歩", "4七歩", "3七歩", "2七歩", "1七歩",
        "8八角", "2八飛",
        "9九香", "8九桂", "7九銀", "6九金", "5九玉", "4九金", "3九銀", "2九桂", "1九香",
      ]
    end

    def arrow
      @location == :black ? "" : "↓"
    end

    # FIXME: 先手後手と、位置は別に考えた方がいい
    def location_mark
      @location == :black ? "▲" : "▽"
    end

    # 必ず存在する持駒を参照する
    def piece_fetch!(piece)
      piece_fetch(piece) or raise PieceNotFound, "持駒に#{piece.name}がありません\n#{board_with_pieces}"
    end

    # 持駒を参照する
    def piece_fetch(piece)
      @pieces.find{|e|e.class == piece.class}
    end

    # 持駒を取り出す
    def pick_out(piece)
      @pieces.delete(piece_fetch!(piece))
    end

    def soldiers
      @board.surface.values.find_all{|soldier|soldier.player == self}
    end

    def move_to(a, b, promote_trigger = false)
      a = Point.parse(a)
      b = Point.parse(b)

      if promote_trigger
        if a.promotable?(location) || b.promotable?(location)
        else
          raise NotPromotable, "#{a.name}から#{b.name}への移動では成れません"
        end

        _soldier = @board.fetch(a)
        if _soldier.promoted
          raise AlredyPromoted, "#{_soldier.point.name}の#{_soldier.piece.name}はすでに成っています"
        end
      end

      soldier = @board.pick_up!(a)
      target_soldier = @board.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.formality_name}があります"
        end
        @board.pick_up!(b)
        @pieces << target_soldier.piece
        @last_piece = target_soldier.piece
      end

      if promote_trigger
        soldier.promoted = true
      end

      @board.put_on_at(b, soldier)
    end

    def next_player
      if @frame
        @frame.players[@frame.players.find_index(self).next.modulo(frame.players.size)]
      else
        self
      end
    end

    # soldier_names # => ["▽5五飛↓"]
    def soldier_names
      soldiers.collect(&:formality_name).sort
    end

    def piece_names
      pieces.collect(&:formality_name).sort
    end

    def piece_discard
      @pieces.clear
    end

    # FIXME: dry
    def execute(str)
      if str == "投了"
        # last_info_reset
        return
      end

      @last_piece = nil

      regexp = /\A(?<point>同|..)#{WHITE_SPACE}*(?<piece>#{Piece.names.join("|")})(?<options>[不成打右左直引寄上]+)?(\((?<from>.*)\))?/
      md = str.match(regexp)
      md or raise SyntaxError, "表記が間違っています : #{str.inspect} (#{regexp.inspect} にマッチしません)"

      if md[:point] == "同"
        point = next_player.moved_point
        unless point
          raise BeforePointNotFound, "同に対する座標が不明です : #{str.inspect}"
        end
      else
        point = Point.parse(md[:point])
      end

      promoted, piece = Piece.parse!(md[:piece])

      promote_trigger = false
      case md[:options].to_s
      when /不成/
      when /成/
        promote_trigger = true
      end

      put_on_trigger = md[:options].to_s.match(/打/)
      source_point = nil

      done = false
      if put_on_trigger
        if promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{str.inspect}"
        end
        @board.put_on_at(point, Soldier.new(self, pick_out(piece), promoted))
        done = true
      else
        if md[:from]
          source_point = Point.parse(md[:from])
        end

        unless source_point
          soldiers = soldiers().find_all{|soldier|soldier.moveable_points.include?(point)}
          soldiers = soldiers.find_all{|e|e.piece.class == piece.class}
          soldiers = soldiers.find_all{|e|e.promoted == promoted}
          candidate = soldiers.collect{|s|s.clone}

          if soldiers.empty?
            if piece_fetch(piece)

              # FIXME: dry
              put_on_trigger = true
              if promoted
                raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{str.inspect}"
              end
              @board.put_on_at(point, Soldier.new(self, pick_out(piece), promoted))
              done = true

            else
              raise MovableSoldierNotFound, "#{point.name}に移動できる#{piece.name}がありません。#{str.inspect} の指定が間違っているのかもしれません"
            end
          end

          unless done
            if soldiers.size > 1
              if md[:options]
                _validate(str, md, "左右直")
                _validate(str, md, "引上寄")
                __saved_soldiers = soldiers
                if piece.kind_of?(Piece::Rook) && false
                  # if md[:options].match(/右/)
                  #   if @location == :black
                  #     soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.last(1)
                  #   else
                  #     soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.first(1)
                  #   end
                  # end
                  # if md[:options].match(/左/)
                  #   if @location == :black
                  #     soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.first(1)
                  #   else
                  #     soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.last(1)
                  #   end
                  # end
                else
                  if piece.kind_of?(Piece::Brave)
                    if md[:options].match(/右/)
                      if @location == :black
                        soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.last(1)
                      else
                        soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.first(1)
                      end
                    end
                    if md[:options].match(/左/)
                      if @location == :black
                        soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.first(1)
                      else
                        soldiers = soldiers.sort_by{|soldier|soldier.point.x.value}.last(1)
                      end
                    end
                  else
                    if md[:options].match(/右/)
                      if @location == :black
                        soldiers = soldiers.find_all{|soldier|point.x.value < soldier.point.x.value}
                      else
                        soldiers = soldiers.find_all{|soldier|point.x.value > soldier.point.x.value}
                      end
                      # if soldiers.size > 1
                      #   soldiers = soldiers.find_all{|soldier|point.y == soldier.point.y}
                      # end
                    end
                    if md[:options].match(/左/)
                      if @location == :black
                        soldiers = soldiers.find_all{|soldier|point.x.value > soldier.point.x.value}
                      else
                        soldiers = soldiers.find_all{|soldier|point.x.value < soldier.point.x.value}
                      end
                      # if soldiers.size > 1
                      #   soldiers = soldiers.find_all{|soldier|point.y == soldier.point.y}
                      # end
                    end
                  end

                  if md[:options].match(/上/)
                    if @location == :black
                      soldiers = soldiers.find_all{|soldier|point.y.value < soldier.point.y.value}
                    else
                      soldiers = soldiers.find_all{|soldier|point.y.value > soldier.point.y.value}
                    end
                    # if soldiers.size > 1
                    #   soldiers = soldiers.find_all{|soldier|point.x == soldier.point.x} # 同じ列
                    # end
                  end
                  if md[:options].match(/引/)
                    if @location == :black
                      soldiers = soldiers.find_all{|soldier|point.y.value > soldier.point.y.value}
                    else
                      soldiers = soldiers.find_all{|soldier|point.y.value < soldier.point.y.value}
                    end
                  end

                  if md[:options].match(/寄/)
                    soldiers = soldiers.find_all{|soldier|soldier.point.y == point.y}
                  end
                  if md[:options].match(/直/)
                    soldiers = soldiers.find_all{|soldier|soldier.point.x == point.x}
                  end
                end
                if soldiers.empty?
                  raise AmbiguousFormatError, "#{point.name}に移動できる駒がなくなった。#{str.inspect} の表記を明確にしてください。(移動元候補だったけどなくなってしまった駒: #{__saved_soldiers.collect(&:formality_name).join(', ')})\n#{board_with_pieces}"
                end
              end
              if soldiers.size > 1
                raise AmbiguousFormatError, "#{point.name}に移動できる駒が多すぎます。#{str.inspect} の表記を明確にしてください。(移動元候補: #{soldiers.collect(&:formality_name).join(', ')})\n#{board_with_pieces}"
              end
            end

            source_point = Point[@board.surface.invert[soldiers.first]]
          end
        end

        unless done
          source_soldier = @board.fetch(source_point)

          unless promote_trigger
            if source_soldier.promoted && !promoted

              # 成駒を成ってない状態にして移動しようとした場合は、いったん持駒を確認する
              if piece_fetch(piece)
                put_on_trigger = true
                source_point = nil
                @board.put_on_at(point, Soldier.new(self, pick_out(piece), promoted))
                done = true
              else
                raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{str.inspect}の駒は#{source_soldier.piece_current_name}と書いてください\n#{board_with_pieces}"
              end

            end
          end

          unless done
            move_to(source_point, point, promote_trigger)
          end
        end
      end

      @next_player_moved_point = next_player.moved_point
      @before_promoted        = promoted
      @before_piece           = piece
      @moved_point            = point
      @from_point             = source_point
      @before_promote_trigger = promote_trigger
      @before_put_on_trigger  = put_on_trigger
      @candidate              = candidate
    end

    def _validate(str, md, chars)
      _chars = chars.scan(/./).find_all{|v|md[:options].include?(v)}
      if _chars.size > 1
        raise SyntaxError, "#{_chars.join('と')}は同時に指定できません。【#{str}】を見直してください。\n#{board_with_pieces}"
      end
    end

    # def last_info_reset
    #   @before_promoted        = nil
    #   @before_piece           = nil
    #   @moved_point           = nil
    #   @from_point    = nil
    #   @before_promote_trigger = nil
    #   @before_put_on_trigger  = nil
    # end

    def last_info
      {
        :next_player_moved_point => @next_player_moved_point,
        :before_promoted        => @before_promoted,
        :before_promote_trigger => @before_promote_trigger,
        :from_point             => @from_point,
        :moved_point            => @moved_point,
        :before_piece           => @before_piece,
        :before_put_on_trigger  => @before_put_on_trigger,
        :candidate              => @candidate,
        :last_piece             => @last_piece,
      }
    end

    #  @before_piece=<Bushido::Piece::Rook:70167310927440 飛 rook>,
    #  @moved_point=#<Bushido::Point:70167308998220 "5一">,
    #  @before_promote_trigger=true,
    #  @before_put_on_trigger=false,
    #  @from_point=#<Bushido::Point:70167310511120 "5五">,
    def last_a_move
      # return if @before_piece.nil?

      s = []
      # if @next_player_moved_point == @moved_point
      #   s << "同"
      # else
      # end
      s << @moved_point.name
      s << @before_piece.some_name(@before_promoted)
      if @before_promote_trigger
        s << "成"
      end
      if @before_put_on_trigger
        s << "打"
      end
      if @from_point
        s << "(#{@from_point.number_format})"
      end
      s.join
    end

    def last_a_move2
      [last_a_move, last_a_move_kif2]
    end

    def last_a_move_kif2
      # {:before_promoted=>true,
      #  :before_promote_trigger=>nil,
      #  :from_point=>#<Bushido::Point:70361068894000 "4六">,
      #  :moved_point=>#<Bushido::Point:70361082976580 "5五">,
      #  :before_piece=><Bushido::Piece::Pawn:70361068615920 歩 pawn>,
      #  :before_put_on_trigger=>nil,
      #  :candidate=>
      #   [<Bushido::Soldier:70361082478820 ▲6六と>,
      #    <Bushido::Soldier:70361084689580 ▲5六と>,
      #    <Bushido::Soldier:70361084645540 ▲5五と>]}

      # return if @before_piece.nil?

      s = []
      if @next_player_moved_point == @moved_point
        s << "同"
      else
        s << @moved_point.name
      end
      s << @before_piece.some_name(@before_promoted)

      # 候補が2つ以上あったとき
      if @candidate && @candidate.size > 1
        if @before_piece.kind_of?(Piece::Brave)
          # 大駒の場合、
          # 【移動元で二つの龍が水平線上にいる】or【移動先の水平線上よりすべて上かすべて下】
          if @candidate.collect{|s|s.point.y.value}.uniq.size == 1 || [     # 移動元で二つの龍が水平線上にいる
              @candidate.all?{|s|s.point.y.value < @moved_point.y.value},   # 移動先の水平線上よりすべて上または
              @candidate.all?{|s|s.point.y.value > @moved_point.y.value},   #                     すべて下
            ].any?

            sorted_candidate = @candidate.sort_by{|soldier|soldier.point.x.value}
            if sorted_candidate.last.point.x.value == @from_point.x.value
              s << select_char("右左")
            end
            if sorted_candidate.first.point.x.value == @from_point.x.value
              s << select_char("左右")
            end
          end
        else
          # 普通駒の場合、
          # 左右がつくのは移動先の左側と右側の両方に駒があるとき
          if [@candidate.any?{|s|s.point.x.value < @moved_point.x.value},      # 移動先の左側に駒がある、かつ
              @candidate.any?{|s|s.point.x.value > @moved_point.x.value}].all? # 移動先の右側に駒がある
            if @moved_point.x.value < @from_point.x.value
              s << select_char("右左")
            end
            if @moved_point.x.value > @from_point.x.value
              s << select_char("左右")
            end
          end

          # 目標座標の左方向または右方向に駒があって、自分は縦の列から来た場合
          if [@candidate.any?{|s|s.point.x.value < @moved_point.x.value},
              @candidate.any?{|s|s.point.x.value > @moved_point.x.value}].any?
            if @moved_point.x.value == @from_point.x.value
              s << "直"
            end
          end
        end

        # 目標地点の上と下、両方にあって区別がつかないとき、
        if [@candidate.any?{|s|s.point.y.value < @moved_point.y.value},
            @candidate.any?{|s|s.point.y.value > @moved_point.y.value}].all? ||
            # 上か下にあって、水平線にもある
            [@candidate.any?{|s|s.point.y.value < @moved_point.y.value},
            @candidate.any?{|s|s.point.y.value > @moved_point.y.value}].any? && @candidate.any?{|s|s.point.y.value == @moved_point.y.value}

          # 下から来たのなら、ひき"上"げる
          if @moved_point.y.value < @from_point.y.value
            s << select_char("上引")
          end
          # 上から来たなら、"引"く
          if @moved_point.y.value > @from_point.y.value
            s << select_char("引上")
          end
        end

        # 目標座標の上方向または下方向に駒があって、自分は真横の列から来た場合
        if [@candidate.any?{|s|s.point.y.value < @moved_point.y.value},
            @candidate.any?{|s|s.point.y.value > @moved_point.y.value}].any?
          if @moved_point.y.value == @from_point.y.value
            s << "寄"
          end
        end
      end

      if @before_promote_trigger
        s << "成"
      else
        if @from_point && @moved_point
          if @from_point.promotable?(@location) || @moved_point.promotable?(@location)
            unless @before_promoted
              s << "不成"
            end
          end
        end
      end

      if @before_put_on_trigger
        s << "打"
      end

      s.join
    end

    def board_with_pieces
      s = ""
      s << @board.to_s(:kakiki)
      # s << "#{location_mark}の持駒:" + pieces.collect(&:formality_name).join + "\n"
      s << "#{location_mark}の持駒:#{pieces_compact_str}\n"
      s
    end

    # Player.test_case2.pieces_compact_str # => "歩九 角 飛 香二 桂二 銀二 金二 玉"
    def pieces_compact_str
      pieces.group_by{|e|e.class}.collect{|klass, pieces|
        if pieces.size > 1
          num = pieces.size.to_s.tr("0-9", "〇一二三四五六七八九")
        else
          num = ""
        end
        "#{pieces.first.name}#{num}"
      }.join(SEPARATOR)
    end

    def select_char(str)
      chars = str.scan(/./)
      if @location == :black
        chars.first
      else
        chars.last
      end
    end
  end
end
