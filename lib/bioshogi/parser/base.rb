# -*- compile-command: "bundle execute rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  module Parser
    class Base
      include Formatter::ParserMethods

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
            :analyzer_enable           => true,
            :analyzer_technique_enable => true,
            :ki2_function               => true,  # ki2にしないのであれば指定するとかなり速くなる

            :validate_enable                => true,  # 将棋ウォーズの棋譜なら指定すると少し速くなる
            :validate_double_pawn_skip      => false, # 二歩を無視するか？
            :validate_warp_skip             => false, # 角ワープを無視するか？
          }
        end
      end

      attr_accessor :pi
      attr_accessor :parser_options

      def initialize(source, parser_options = {})
        @source = Source.wrap(source)
        @parser_options = self.class.default_parser_options.merge(parser_options)
        @pi = Pi.new
      end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def normalized_source
        @normalized_source ||= @source.to_s
      end

      def inspect
        Inspector.new(self).inspect
      end
    end
  end
end
