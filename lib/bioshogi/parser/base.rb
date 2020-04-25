# -*- compile-command: "bundle execute rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

require_relative "header"

module Bioshogi
  module Parser
    class Base
      include Formatter::Anything

      cattr_accessor(:header_sep) { "：" }

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
      end

      attr_reader :move_infos, :first_comments, :last_status_params, :board_source, :error_message

      def initialize(source, parser_options = {})
        @source = source
        @parser_options = default_parser_options.merge(parser_options)

        @move_infos = []
        @first_comments = []
        @board_source = nil
        @last_status_params = nil
        @error_message = nil
      end

      def default_parser_options
        {
          # embed: 二歩の棋譜なら例外を出さずに直前で止めて反則であることを棋譜に記す
          #  skip: 棋譜には記さない
          # false: 例外を出す(デフォルト)
          typical_error_case: false,
          # run_and_build_skip: false,
          skill_monitor_enable: true,
          skill_monitor_technique_enable: true,

          validate_enable: true,           # 将棋ウォーズの棋譜なら指定すると少し速くなる
          candidate_enable: true, # ki2にしないのであれば指定するとかなり速くなる

          support_for_piyo_shogi_v4_1_5: false, # ぴよ将棋でKIFが読めるようにする
        }
      end

      # def parse
      #   unless @parser_options[:run_and_build_skip]
      #     mediator_run
      #   end
      # end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source)
      end

      def header
        @header ||= Header.new
      end

      private

      def header_read
        header.parse_from_kif_format_header(normalized_source)
      end

      def header_normalize
        header.normalize_all
      end

      # for KIF, KI2
      def board_read
        if md = normalized_source.match(/(?<board>^\+\-.*\-\+$)/m)
          @board_source = md[:board]
        end
      end

      # for KIF, KI2
      def comment_read(line)
        if md = line.match(/^\p{blank}*\*\p{blank}*(?<comment>.*)/)
          if @move_infos.empty?
            first_comments_add(md[:comment])
          else
            note_add(md[:comment])
          end
        end
      end

      def first_comments_add(comment)
        @first_comments << comment
      end

      # コメントは直前の棋譜の情報と共にする
      def note_add(comment)
        @move_infos.last[:comments] ||= []
        @move_infos.last[:comments] << comment
      end
    end
  end
end
