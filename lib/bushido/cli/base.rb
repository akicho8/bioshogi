# -*- compile-command: "ruby base.rb" -*-
# frozen-string-literal: true

require_relative "../../bushido"

require "optparse"

module Bushido
  module Cli
    class << self
      def command_keys
        Pathname.glob("#{__dir__}/*_command.rb").collect {|e| e.basename(".*").to_s.remove(/_command/) }
      end

      def command_classes
        command_keys.collect(&method(:command_class))
      end

      def command_class(s)
        "bushido/cli/#{s}_command".classify.constantize
      end

      def execute(args = ARGV, options = {})
        options = default_options.merge(options)

        opts = OptionParser.new
        opts.version = "1.0.0"

        opts.banner = [
          "将棋 #{opts.ver}\n",
          "使い方: #{opts.program_name} <コマンド> [<オプション>] [<引数>]\n",
        ].join

        opts.separator("")
        opts.separator("共通オプション:")

        opts.on("--debug", "デバッグモード(初期値:#{default_options[:debug]})") { |v| options[:debug] = v }

        opts.separator("コマンド:")

        opts.on command_classes.collect { |e|
          [opts.summary_indent, e.key.ljust(16), e.command_name].join + "\n"
        }.join

        args = opts.order(args)

        if args.empty?
          puts opts.help
          exit(1)
        end

        command_name = args.shift
        klass = command_class(command_name)
        klass.new(args, options).execute
      end

      def default_options
        {
          debug: false,
        }
      end
    end

    class Base
      class << self
        def key
          name.demodulize.underscore.remove(/_command/)
        end
      end

      class_attribute :command_name

      attr_accessor :options

      def initialize(args, options)
        @args = args
        @options = options
      end

      def execute
      end
    end
  end
end

Pathname.glob("#{__dir__}/*_command.rb").each { |e| require e }

if $0 == __FILE__
  Bushido::Cli.execute(ARGV)
end
