# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/utils_spec.rb" -*-
#
# 汎用の便利メソッド集
#

module Bushido
  module Utils
    extend self

    # 指定プレイヤー側の初期配置(「角落ち」などを指定可)
    #   Utils.location_soldiers(:black, "平手")         # => ["9七歩", "8七歩", ...]
    #   Utils.location_soldiers(:black, "角落ち")       # => ["9七歩", "8七歩", ...]
    #   Utils.location_soldiers(:black, "+----+\n|...") # => [...]
    def location_soldiers(params)
      params = {
        :location => nil,
        :key => nil,
      }.merge(params)

      if BaseFormat.board_format?(params[:key])
        stock = Stock.new(:board => params[:key])
        r = both_soldiers_from_char_board2(params.merge(:stock => stock))
        r[L.b]
      else
        stock = Stock.list.find{|v|v[:key] == params[:key]}
        stock or raise BoardKeyNotFound, "盤面データがありません : #{params[:key].inspect}"
        r = valid_both_soldiers_from_char_board(params.merge(:stock => stock))
        r[L.b]
      end
    end

    # 指定プレイヤー側の初期配置(盤面のみ対応)
    #   Utils.location_soldiers(:black, "+----+\n|...") # => [...]
    def valid_both_soldiers_from_char_board(params = {})
      params = {
        :validate => true,
      }.merge(params)
      if params[:validate]
        if params[:stock].parsed_board[:white].present?
          raise BoardIsBlackOnly, "後手側データは定義できません : #{params[:stock].parsed_board[:white].inspect}"
        end
      end
      both_soldiers_from_char_board2(params)
    end

    def both_soldiers_from_char_board2(params)
      params[:stock].parsed_board.inject({}){|h, (key, value)|
        h.merge(key => value.collect{|s|s.merge(:point => s[:point].as_location(params[:location]))})
      }
    end

    # board_reset の引数の解釈
    #
    #   board_reset_args("+-----")                              # そのまま棋譜が入ってれいばそのままパース
    #   board_reset_args("角落ち")                              # 先手だけが角落ち(下と同じ)
    #   board_reset_args("先手" => "角落ち", "後手" => "平手")  # 先手だけが角落ち
    #
    #   => {
    #       "先手" => [<MiniSoldier>, ...],
    #       "後手" => [<MiniSoldier>, ...],
    #     }
    #
    def board_reset_args(value = nil)
      case
      when BaseFormat.board_format?(value)
        # Stock.new(:board => value).parsed_board
        BaseFormat.board_parse(value)
      when Hash === value
        # {"先手" => "角落ち", "後手" => "香落ち"}
        value.inject({}){|hash, (k, v)|
          hash.merge(Location[k] => Utils.location_soldiers(:location => k, :key => v))
        }
      else
        # "角落ち" なら {"先手" => "角落ち", "後手" => "平手"}
        board_reset_args(:black => (value || "平手"), :white => "平手")
      end
    end

    # def board_init_type2(value = nil)
    #   if Hash === value
    #     # {"先手" => "角落ち", "後手" => "香落ち"}
    #     value.inject({}){|hash, (k, v)|hash.merge(k => Utils.location_soldiers(k, v))}
    #   elsif BaseFormat.board_format?(value)
    #     BaseFormat.board_parse(value)
    #   else
    #     # "角落ち" なら {"先手" => "角落ち", "後手" => "平手"}
    #     board_init_type2("先手" => (value || "平手"), "後手" => "平手")
    #   end
    # end

    # 持駒表記変換 (人間表記 → コード)
    #  Utils.stand_pack([Piece["歩"], Piece["歩"], Piece["飛"]]).should == "歩二 飛"
    def stand_pack(pieces)
      pieces.group_by{|e|e.class}.collect{|klass, pieces|
        count = ""
        if pieces.size > 1
          count = pieces.size.to_s.tr("0-9", "〇一二三四五六七八九")
        end
        "#{pieces.first.name}#{count}"
      }.join(SEPARATOR)
    end

    # 持駒表記変換 (コード → 人間表記)
    #   Utils.stand_unpack("歩2 飛").should == [Piece["歩"], Piece["歩"], Piece["飛"]]
    def stand_unpack(str)
      if String === str
        str = str.tr("〇一二三四五六七八九", "0-9")
        infos = str.split(/#{WHITE_SPACE}+/).collect{|s|
          md = s.match(/\A(?<piece>#{Piece.collect(&:basic_names).flatten.join("|")})(?<count>\d+)?\z/)
          md or raise SyntaxError, "例:「飛 歩2」 : #{str.inspect}"
          {:piece => md[:piece], :count => (md[:count] || 1).to_i}
        }
      else
        infos = str
      end
      pieces_parse2(infos)
    end

    def pieces_parse2(list)
      Array.wrap(list).collect{|info|
        (info[:count] || 1).times.collect{ Piece.fetch(info[:piece]) }
      }.flatten
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

    # ki2形式に近い棋譜の羅列のパース
    #   ki2_parse("▲４二銀△４二銀") # => [{:location => :black, :input => "４二銀"}, {:location => :white, :input => "４二銀"}]
    def ki2_parse(str)
      str = str.to_s
      str = str.gsub(/([#{Location.triangles}])/, ' \1')
      str = str.squish
      str.split(/\s+/).collect{|s|
        if s.match(/\A[#{Location.triangles}]/)
          mov_split(s)
        else
          s
        end
      }.flatten
    end

    def mov_split(str)
      Array.wrap(str).join(" ").scan(/([#{Location.triangles}])([^#{Location.triangles}\s]+)/).collect{|mark, input|{:location => Location[mark], :input => input}}
    end

    private

    # def initial_placements
    #   [
    #     "9七歩", "8七歩", "7七歩", "6七歩", "5七歩", "4七歩", "3七歩", "2七歩", "1七歩",
    #     "8八角", "2八飛",
    #     "9九香", "8九桂", "7九銀", "6九金", "5九玉", "4九金", "3九銀", "2九桂", "1九香",
    #   ].compact
    # end
  end
end
