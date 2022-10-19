# frozen-string-literal: true

module Bioshogi
  class Sfen
    STARTPOS_EXPANSION = "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    BOARD_REGEXP       = "[#{Piece.collect(&:sfen_char).join}1-9+\/]+"
    LOCATION_REGEXP    = "[#{Location.collect(&:to_sfen).join}]"
    SFEN_REGEXP        = /(?:position\s+)?(?:sfen\s+)?(?<board>#{BOARD_REGEXP})\s+(?<b_or_w>#{LOCATION_REGEXP})\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)(\s+moves\s+(?<moves>.*))?/i

    attr_reader :attributes
    attr_reader :source

    class << self
      def accept?(source)
        source.sub(/startpos/, STARTPOS_EXPANSION).match?(SFEN_REGEXP)
      end

      def parse(source)
        new(source).tap(&:parse)
      end

      # position startpos を逆に position sfen ... 形式に変換
      def startpos_remove(s)
        s.sub(/startpos/, STARTPOS_EXPANSION)
      end

      # startpos スタイルに変更
      def startpos_embed(s)
        s.sub(STARTPOS_EXPANSION, "startpos")
      end
    end

    def initialize(source)
      @source = source
    end

    def parse
      s = self.class.startpos_remove(source)
      if !md = s.match(SFEN_REGEXP)
        m = []
        m << "入力のSFEN形式が不正確です"
        if source.match?(/\s{2,}/)
          m << "連続するスペースが含まれている個所が壊れているかもしれません"
        end
        if source.strip.match?(/\R/)
          m << "途中で改行を含めないでください"
        end
        m = m.join("。")
        m = "#{m} : #{source.strip.inspect}"
        raise SyntaxDefact, m
      end
      @attributes = md.named_captures.symbolize_keys
    end

    def soldiers
      BoardParser::SfenBoardParser.parse(attributes[:board]).soldiers
    end

    def location
      Location.fetch(attributes[:b_or_w])
    end

    def piece_counts
      hash = Location.inject({}) { |a, e| a.merge(e.key => {}) }
      if str = attributes[:hold_pieces]
        if str != "-"
          str.scan(/(\d+)?(.)/) do |count, ch|
            count = (count || 1).to_i
            piece = Piece.fetch_by_sfen_char(ch)
            location = Location.fetch_by_sfen_char(ch)
            hash[location.key].update(piece.key => count) { |_, *c| c.sum }
          end
        end
      end
      hash
    end

    # 現在の局面+1が記載されているので -1 すること
    def turn_base
      if v = attributes[:turn_counter_next]
        v.to_i.pred
      end
    end

    def handicap?
      turn_base.even? && location.key == :white
    end

    def move_infos
      moves.collect { |e| { input: e } }
    end

    ################################################################################ 簡単にアクセスするためのメソッド

    def moves
      attributes[:moves].to_s.split
    end

    def board_and_b_or_w_and_piece_box_and_turn
      attributes.fetch_values(:board, :b_or_w, :hold_pieces, :turn_counter_next).join(" ")
    end

    def kento_app_url
      "https://www.kento-shogi.com/?#{kento_app_query_hash.to_query}"
    end

    def kento_app_query_hash
      { initpos: board_and_b_or_w_and_piece_box_and_turn, moves: moves.join(".") }
    end

    def to_h
      {
        :soldiers     => soldiers,
        :piece_counts => piece_counts,
        :location     => location,
        :moves        => moves,
      }
    end
  end
end
