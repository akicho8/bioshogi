# -*- coding: utf-8; compile-command: "be ruby cli.rb" -*-

require_relative "../bushido"

require "optparse"

module Bushido
  class Cli
    Commands = [
      "PieceList",
      "Versus",
    ]

    attr_accessor :options

    def self.default_options
      {
        :debug => false,
      }
    end

    def self.common_options(option_parser, options)
      option_parser.on("--debug", "デバッグモード(初期値#{default_options[:debug]})"){|v|options[:debug] = v}
    end

    def self.process_args(args, options = {})
      options = default_options.merge(options)
      opts = OptionParser.new
      opts.version = "1.0.0"
      opts.banner = [
        "将棋 #{opts.ver}",
        "使用方法: #{opts.program_name} <COMMAND> [<オプション>] [<引数>]",
      ].collect{|e|e + "\n"}.join
      opts.separator("共通オプション:")
      common_options(opts, options)
      opts.separator("COMMAND:")
      opts.on(Commands.collect{|sub_command|
          klass = "Bushido::Cli::#{sub_command.camelize}".constantize
          "#{opts.summary_indent}#{sub_command.underscore.ljust(16)} #{klass.script_name}\n"}.join
        )
      opts.order!(args)
      if args.empty?
        puts opts.help
        exit(1)
      end
      [args, options]
    end

    def self.execute(args = ARGV, options = {})
      new(*process_args(args, options)).execute
    end

    def initialize(args, options)
      @args = args
      @options = options
    end

    def execute
      command_name = @args.first
      klass = "Bushido::Cli::#{command_name.camelize}".constantize
      klass.new(*klass.process_args(@args, @options)).execute
    end

    def message(str)
      puts str
    end
  end
end

require_relative "cli/piece_list"
require_relative "cli/versus"

if $0 == __FILE__
  Bushido::Cli.execute(ARGV)
end
