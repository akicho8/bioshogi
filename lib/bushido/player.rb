# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  class Player
    # facade
    def self.test_case(params)
      params = {
        :player => :black,
        :return_player => false,
      }.merge(params)
      player = Player.create2(params[:player], Board.new)
      player.deal2(params[:deal])
      player.initial_put_on(params[:init])
      Array.wrap(params[:exec]).each{|v|player.execute(v)}
      if params[:return_player]
        player
      else
        player.soldier_names.sort
      end
    end

    # facade
    def self.test_case2(params)
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

    attr_accessor :name, :board, :location, :pieces, :frame, :before_point

    def initialize
      @pieces = []
    end

    def deal
      first_distributed_pieces.each{|info|deal2(info)}
    end

    def deal2(infos)
      if infos.kind_of? String
        infos = infos.scan(/./).collect{|piece|{:piece => piece}}
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
        next if arg.blank?      # テストを書きやすくするため
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

    def piece_fetch!(piece)
      piece_fetch(piece) or raise PieceNotFound, "持駒に#{piece.name}がありません\n#{board_with_pieces}"
    end

    def piece_fetch(piece)
      @pieces.find{|e|e.class == piece.class}
    end

    def pick_out(piece)
      @pieces.delete(piece_fetch!(piece))
    end

    def soldiers
      @board.matrix.values.find_all{|soldier|soldier.player == self}
    end

    def move_to(a, b, promote_trigger = false)
      a = Point.parse(a)
      b = Point.parse(b)

      if promote_trigger
        if a.promotable_area?(location) || b.promotable_area?(location)
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
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.name}があります"
        end
        @board.pick_up!(b)
        @pieces << target_soldier.piece
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
      soldiers.collect(&:to_text).sort
    end

    def piece_names
      pieces.collect(&:name).sort
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

      white_space = /\s#{[0x3000].pack('U')}/

      regexp = /\A(?<point>同|..)[#{white_space}]*(?<piece>#{Piece.names.join("|")})(?<options>[成打右左直引寄上]+)?(\((?<from>.*)\))?/
      md = str.match(regexp)
      md or raise SyntaxError, "表記が間違っています : #{str.inspect} (#{regexp.inspect} にマッチしません)"

      if md[:point] == "同"
        point = next_player.before_point
        unless point
          raise BeforePointNotFound, "同に対する座標が不明です : #{str.inspect}"
        end
      else
        point = Point.parse(md[:point])
      end

      promoted, piece = Piece.parse!(md[:piece])
      promote_trigger = md[:options].to_s.match(/成/)
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
          candidate = soldiers

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
                  raise AmbiguousFormatError, "#{point.name}に移動できる駒がなくなった。#{str.inspect} の表記を明確にしてください。(移動元候補だったけどなくなってしまった駒: #{__saved_soldiers.collect(&:name).join(', ')})\n#{board_with_pieces}"
                end
              end
              if soldiers.size > 1
                raise AmbiguousFormatError, "#{point.name}に移動できる駒が多すぎます。#{str.inspect} の表記を明確にしてください。(移動元候補: #{soldiers.collect(&:name).join(', ')})\n#{board_with_pieces}"
              end
            end

            source_point = Point[@board.matrix.invert[soldiers.first]]
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

      @before_promoted        = promoted
      @before_piece           = piece
      @before_point           = point
      @before_source_point    = source_point
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
    #   @before_point           = nil
    #   @before_source_point    = nil
    #   @before_promote_trigger = nil
    #   @before_put_on_trigger  = nil
    # end

    def last_info
      {
        :before_promoted        => @before_promoted,
        :before_promote_trigger => @before_promote_trigger,
        :before_source_point    => @before_source_point,
        :before_point           => @before_point,
        :before_piece           => @before_piece,
        :before_put_on_trigger  => @before_put_on_trigger,
        :candidate              => @candidate,
      }
    end

    #  @before_piece=<Bushido::Piece::Rook:70167310927440 飛 rook>,
    #  @before_point=#<Bushido::Point:70167308998220 "5一">,
    #  @before_promote_trigger=true,
    #  @before_put_on_trigger=false,
    #  @before_source_point=#<Bushido::Point:70167310511120 "5五">,
    def last_a_move
      # return if @before_piece.nil?

      s = []
      s << @before_point.name
      s << @before_piece.some_name(@before_promoted)
      if @before_promote_trigger
        s << "成"
      end
      if @before_put_on_trigger
        s << "打"
      end
      if @before_source_point
        s << "(#{@before_source_point.to_s_digit})"
      end
      s.join
    end

    def last_a_move2
      [last_a_move, last_a_move_kif2]
    end

    def last_a_move_kif2
# {:before_promoted=>true,
#  :before_promote_trigger=>nil,
#  :before_source_point=>#<Bushido::Point:70361068894000 "4六">,
#  :before_point=>#<Bushido::Point:70361082976580 "5五">,
#  :before_piece=><Bushido::Piece::Pawn:70361068615920 歩 pawn>,
#  :before_put_on_trigger=>nil,
#  :candidate=>
#   [<Bushido::Soldier:70361082478820 ▲6六と>,
#    <Bushido::Soldier:70361084689580 ▲5六と>,
#    <Bushido::Soldier:70361084645540 ▲5五と>]}

      # return if @before_piece.nil?

      s = []
      s << @before_point.name
      s << @before_piece.some_name(@before_promoted)
      if @before_promote_trigger
        s << "成"
      end
      if @before_put_on_trigger
        s << "打"
      end
      if @candidate.size >= 3
        if @before_point.x.value < @before_source_point.x.value
          s << "右"
        end
      end
      s.join
    end

    # def up_to_down(soldiers)
    #   if @location == :black
    #     soldiers = soldiers.find_all{|soldier|point.y.value > soldier.point.y.value}
    #   else
    #     soldiers = soldiers.find_all{|soldier|point.y.value < soldier.point.y.value}
    #   end
    #   soldiers
    # end

    def board_with_pieces
      s = ""
      s << @board.to_s(:kakiki)
      s << "#{location_mark}の持駒:" + pieces.collect(&:name).join + "\n"
      s
    end
  end
end
