# -*- compile-command: "ruby base.rb piece_list" -*-

module Bushido
  module Cli
    class PieceListCommand < Base
      def self.command_name
        "駒情報一覧"
      end

      def self.process_args(args, options)
        options = {
          :foo_bar => nil,
        }.merge(default_options).merge(options)

        opts = OptionParser.new
        opts.on("-e", "--email=EMAIL", String, "メールアドレス"){|v|options[:email] = v}
        common_options(opts, options)
        opts.parse!(args)
        [args, options]
      end

      def execute
        Piece.each{|e|p e.name}
      end
    end
  end
end
