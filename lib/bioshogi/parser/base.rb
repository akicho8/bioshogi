# -*- compile-command: "bundle execute rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  module Parser
    class Base
      include Formatter::ExportMethods

      class << self
        def parse(source, options = {})
          new(source, options).tap(&:parse)
        end

        def file_parse(file, options = {})
          parse(Pathname(file).expand_path.read, options)
        end

        def accept?(source)
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def default_parser_options
          {
            # embed: 二歩の棋譜なら例外を出さずに直前で止めて反則であることを棋譜に記す
            #  skip: 棋譜には記さない
            # false: 例外を出す(デフォルト)
            :typical_error_case             => false,
            :skill_monitor_enable           => true,
            :skill_monitor_technique_enable => true,
            :candidate_enable               => true,  # ki2にしないのであれば指定するとかなり速くなる

            :validate_enable                => true,  # 将棋ウォーズの棋譜なら指定すると少し速くなる
            :validate_double_pawn_skip      => false, # 二歩を無視するか？
            :validate_warp_skip             => false, # 角ワープを無視するか？
          }
        end
      end

      attr_accessor :mi
      attr_accessor :error_message
      attr_reader :force_location
      attr_reader :force_handicap
      attr_reader :force_preset_info
      attr_reader :player_piece_boxes
      attr_reader :header
      attr_accessor :parser_options

      def initialize(source, parser_options = {})
        @source = source
        @parser_options = self.class.default_parser_options.merge(parser_options)

        @mi = Mi.new

        @error_message      = nil
        @force_preset_info  = nil
        @force_location     = nil
        @force_handicap     = nil
        @player_piece_boxes = Location.inject({}) {|a, e| a.merge(e.key => PieceBox.new) }
      end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source)
      end

      def inspect
        Inspector.new(self).inspect
      end
    end
  end
end
